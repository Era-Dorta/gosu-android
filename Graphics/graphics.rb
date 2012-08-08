require 'requires'
require 'graphicsBase'
require 'color'

module Gosu
  class Graphics
    attr_reader :width, :height
    attr_reader :fullscreen
    def initialize(physicalWidth, physicalHeight, fullscreen, window)
      @window = window     
      @virtWidth = physicalHeight
      @virtHeight = physicalWidth
      
      @physWidth = physicalWidth
      @physHeight = physicalHeight
      
      @fullscreen = fullscreen
      #Gl stuff moved to render
      
      #TODO include queues @queues
      #TODO include vector of @textures 
      #TODO Set quues to size 1    
    end
    
    def setResolution(virtualWidth, virtualHeight); end

    #Prepares the graphics object for drawing. Nothing must be drawn
    #without calling begin.
    def begin(clearWithColor = Color::BLACK)
      @gl.glClearColor(clearWithColor.red / 255.0, clearWithColor.green / 255.0,
        clearWithColor.blue / 255.0, clearWithColor.alpha / 255.0)
      @gl.glClear(JavaImports::GL10::GL_COLOR_BUFFER_BIT)
      
      return true
    end
    #Every call to begin must have a matching call to end.
    def end; end
    #Flushes the Z queue to the screen and starts a new one.
    #Useful for games that are *very* composite in nature (splitscreen).
    def flush; end
    
    #Finishes all pending Gosu drawing operations and executes
    #the following OpenGL code in a clean environment.
    def beginGL; end
    #Resets Gosu o its default rendering state.
    def endGL; end
    #(Experimental)
    #Schedules a custom GL functor to be executed at a certain Z level.
    #The functor is called in a clean GL context (as given by beginGL/endGL).
    #Gosu's rendering up to the Z level may not yet have been glFlush()ed.
    #Note: You may not call any Gosu rendering functions from within the
    #functor, and you must schedule it from within Window::draw's call tree.
    def scheduleGL(functor, z); end
    
    #Enables clipping to a specified rectangle.
    def beginClipping(x,  y,  width,  height); end
    #Disables clipping.
    def endClipping; end
    
    #Starts recording a macro. Cannot be nested.
    def beginRecording; end
    #Finishes building the macro and returns it as a drawable object.
    #The width and height affect nothing about the recording process,
    #the resulting macro will simply return these values when you ask
    #it.
    #Most usually, the return value is passed to Image::Image().
    def endRecording(width,  height); end
    
    #Pushes one transformation onto the transformation stack.
    def pushTransform(transform); end
    #Pops one transformation from the transformation stack.
    def popTransform; end

    #Draws a line from one po to another (last pixel exclusive).
    #Note: OpenGL lines are not reliable at all and may have a missing pixel at the start
    #or end po. Please only use this for debugging purposes. Otherwise, use a quad or
    #image to simulate lines, or contribute a better drawLine to Gosu.
    def drawLine( x1,  y1,  c1,
         x2,  y2,  c2,
         z,  mode = AlphaMode::AM_DEFAULT); end

    def drawTriangle( x1,  y1,  c1,
         x2,  y2,  c2,
         x3,  y3,  c3,
         z,  mode = AlphaMode::AM_DEFAULT); end

    def drawQuad( x1,  y1,  c1,
         x2,  y2,  c2,
         x3,  y3,  c3,
         x4,  y4,  c4,
         z,  mode = AlphaMode::AM_DEFAULT); end

    #Turns a portion of a bitmap o something that can be drawn on
    #this graphics object.
    def createImage( src, srcX,  srcY,  srcWidth,  srcHeight,
         borderFlags); end    
    
    def onDrawFrame(gl)
      gl.glClear(JavaImports::GL10::GL_COLOR_BUFFER_BIT | JavaImports::GL10::GL_DEPTH_BUFFER_BIT)
      @window.do_tick
    end
  
    def onSurfaceChanged(gl, width, height)
      @gl = gl
      gl.glViewport(0, 0, width, height)
    end
  
    def onSurfaceCreated(gl, config)
      #gl.glClearColor(1,1,1,1)
      @gl = gl
      gl.glMatrixMode(JavaImports::GL10::GL_PROJECTION)
      gl.glLoadIdentity
      gl.glViewport(0, 0, @window.width, @window.height)

      gl.glOrthof(0, @window.width, @window.height, 0, -1, 1)

      
      gl.glMatrixMode(JavaImports::GL10::GL_MODELVIEW)
      gl.glLoadIdentity
      
      gl.glEnable(JavaImports::GL10::GL_BLEND)         
    end         
  end
end
