package gosu.java;

import javax.microedition.khronos.opengles.GL10;

public class RenderState{
	private static int AM_DEFAULT = 0;
	private static int  AM_ADD = 1;
	private static int AM_MULTIPLY = 2; 

	protected int texName;
	protected int transform;
	protected ClipRect clipRect;
	protected int mode;
	
	public RenderState(){
		texName = ClipRect.NO_TEXTURE;
		transform = 0;
		clipRect = new ClipRect();
		clipRect.setWidth(ClipRect.NO_CLIPPING);
		mode = AM_DEFAULT;
	}
	
	public RenderState(	 int texName_, int transform_, ClipRect clipRect_, int mode_){
		texName = texName_;
		transform = transform_;
		clipRect = clipRect_;
		mode = mode_;				
	}	
	
	public void setTexName(int texName_){
		texName = texName_;
	}
	
	public int getTexName(){
		return texName;
	}

	public void setTransform(int transform_){
		transform = transform_;
	}
	
	public int getTransform(){
		return transform;
	}	
	
	public void setClipRect(ClipRect clipRect_){
		clipRect = clipRect_;
	}
	
	public ClipRect getClipRect(){
		return clipRect;
	}	

	public void setMode(int mode_){
		mode = mode_;
	}
	
	public int getMode(){
		return mode;
	}		
	
	public void applyTexture( GL10 gl ){
        if (texName != ClipRect.NO_TEXTURE)
        {
            gl.glEnable(GL10.GL_TEXTURE_2D);
            gl.glBindTexture(GL10.GL_TEXTURE_2D, texName);
        }else{
            gl.glDisable(GL10.GL_TEXTURE_2D);	
        }
	}
	
	public void applyAlphaMode( GL10 gl ){
        if (mode == AM_ADD){
        	gl.glBlendFunc(GL10.GL_SRC_ALPHA, GL10.GL_ONE);
        }else{ 
        	if (mode == AM_MULTIPLY){
        		gl.glBlendFunc(GL10.GL_DST_COLOR, GL10.GL_ZERO);
	        }else{
	        	gl.glBlendFunc(GL10.GL_SRC_ALPHA, GL10.GL_ONE_MINUS_SRC_ALPHA);	
	        }
        }
	}
	
	public void applyClipRect( GL10 gl ){
        if ( clipRect.getWidth() == (double)ClipRect.NO_CLIPPING){
        	gl.glDisable(GL10.GL_SCISSOR_TEST);
        }else{
        	gl.glEnable(GL10.GL_SCISSOR_TEST);
        	gl.glScissor((int)clipRect.getX(), (int)clipRect.getY(), (int)clipRect.getWidth(), (int)clipRect.getHeight());
        }		
	}
}