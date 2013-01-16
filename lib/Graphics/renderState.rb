require 'lib/Graphics/graphicsBase'
require 'lib/Graphics/common'
require 'lib/requires'

module Gosu
  class RenderState < Struct.new(:tex_name, :transform, :clip_rect, :mode)
    alias :old_initialize :initialize
    
    def initialize(*args)
      case args.length
      #Whith no arguments use default values
      when 0
        self[:tex_name] = NO_TEXTURE
        self[:transform] = 0
        self[:clip_rect] = ClipRect.new
        self[:clip_rect].width = NO_CLIPPING
        self[:mode] = AM_DEFAULT
      else
        #With arguments, use struct's initialize  
        old_initialize *args
      end  
    end
    
    def apply_texture gl
      if self[:tex_name] == NO_TEXTURE
        gl.glDisable(JavaImports::GL10::GL_TEXTURE_2D)
      else    
        gl.glEnable(JavaImports::GL10::GL_TEXTURE_2D)
        gl.glBindTexture(JavaImports::GL10::GL_TEXTURE_2D, self[:tex_name])
      end
    end
 
    def apply_alpha_mode gl         
      if self[:mode] == AM_ADD
        gl.glBlendFunc(JavaImports::GL10::GL_SRC_ALPHA, JavaImports::GL10::GL_ONE)
      else 
        if self[:mode] == AM_MULTIPLY
          gl.glBlendFunc(JavaImports::GL10::GL_DST_COLOR, JavaImports::GL10::GL_ZERO)
        else
          gl.glBlendFunc(JavaImports::GL10::GL_SRC_ALPHA, JavaImports::GL10::GL_ONE_MINUS_SRC_ALPHA)
        end
      end  
    end      
    
    def apply_clip_rect gl
      if self[:clip_rect].width == NO_CLIPPING
        gl.glDisable(JavaImports::GL10::GL_SCISSOR_TEST)
      else
        gl.glEnable(JavaImports::GL10::GL_SCISSOR_TEST)
        gl.glScissor(self[:clip_rect].x, self[:clip_rect].y, self[:clip_rect].width, self[:clip_rect].height)
      end     
    end 
     
  end
  
  class RenderStateManager < RenderState
    def apply_transform gl    
        gl.glMatrixMode(JavaImports::GL10::GL_MODELVIEW)
        gl.glLoadIdentity
        #TODO on C it was (&(*transform)[0]), check to_java
        gl.glMultMatrixd(transform[0])   
    end    
    private :apply_transform
    
    def initialize gl
      super()
      @gl = gl
      #Set finalize
      ObjectSpace.define_finalizer(self,
                          self.class.method(:finalize).to_proc)      
      apply_alpha_mode @gl
      #Preserve previous MV matrix
      @gl.glMatrixMode(JavaImports::GL10::GL_MODELVIEW)
      @gl.glPushMatrix
    end
    
    def RenderStateManager.finalize(id)
        no_clipping = ClipRect.new
        no_clipping.width = NO_CLIPPING
        self.clip_rect = no_clipping
        self.tex_name = NO_TEXTURE
        #Return to previous MV matrix
        @gl.glMatrixMode(JavaImports::GL10::GL_MODELVIEW)
        @gl.glPopMatrix
    end
    
    def render_state= rs
      self.tex_name = rs.tex_name
      self.transform = rs.transform
      self.clip_rect = rs.clip_rect
      self.alpha_mode = rs.mode   
    end
    
    def tex_name= new_tex_name
      if new_tex_name == self[:tex_name]
        return
      end
      if new_tex_name != NO_TEXTURE
        #New texture *is* really a texture - change to it.        
        if (self[:tex_name] == NO_TEXTURE)
          @gl.glEnable(JavaImports::GL10::GL_TEXTURE_2D)
        end  
        @gl.glBindTexture(JavaImports::GL10::GL_TEXTURE_2D, new_tex_name)
      else
          #New texture is NO_TEXTURE, disable texturing.
          @gl.glDisable(JavaImports::GL10::GL_TEXTURE_2D)
      end    
      self[:tex_name] = new_tex_name     
    end
    
    def transform= new_transform
      if new_transform == self[:transform]
        return
      end
        self[:transform] = new_transform
        apply_transform(@gl)
    end
    
    def clip_rect= new_clip_rect
      if new_clip_rect.width == NO_CLIPPING      
          #Disable clipping
          if self[:clip_rect].width != NO_CLIPPING
              @gl.glDisable(JavaImports::GL10::GL_SCISSOR_TEST)
              self[:clip_rect].width = NO_CLIPPING  
          end          
      else
          #Enable clipping if off
          if self[:clip_rect].width == NO_CLIPPING          
              @gl.glEnable(JavaImports::GL10::GL_SCISSOR_TEST)
              self[:clip_rect] = new_clip_rect
              @gl.glScissor(self[:clip_rect].x, self[:clip_rect].y, 
                self[:clip_rect].width, self[:clip_rect].height)          
          #Adjust clipping if necessary
          else 
            if not self[:clip_rect] == new_clip_rect         
              self[:clip_rect] = new_clip_rect
              @gl.glScissor(self[:clip_rect].x, self[:clip_rect].y, 
                self[:clip_rect].width, self[:clip_rect].height)
            end
         end   
      end
    end 
    
    def alpha_mode= new_mode
      if new_mode == self[:mode]
        return
      end    
      self[:mode] = new_mode
      apply_alpha_mode @gl      
    end

    #The cached values may have been messed with. Reset them again.
    def enforce_after_untrusted_GL
      #TODO: Actually, we don't have to worry about anything pushed
      #using glPushAttribs because beginGL/endGL will take care of that.        
      apply_texture @gl
      apply_transform @gl
      apply_clip_rect @gl
      apply_alpha_mode @gl      
    end   
        
  end
end
