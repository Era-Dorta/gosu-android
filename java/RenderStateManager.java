package gosu.java;

import javax.microedition.khronos.opengles.GL10;

public class RenderStateManager extends RenderState{
	
	private GL10 gl;
	
	private void applyTransform(){
        gl.glMatrixMode(GL10.GL_MODELVIEW);
        gl.glLoadIdentity();
        //TODO on C it was (&(*transform)[0]), check to_java
        //gl.glMultMatrixd(transform[0])   		
	}
	
	public RenderStateManager(GL10 gl_){
		super();
	    gl = gl_;
        applyAlphaMode(gl);
        // Preserve previous MV matrix
        gl.glMatrixMode(GL10.GL_MODELVIEW);
        gl.glPushMatrix();
	}
	
/*	protected void finalize () {
        ClipRect noClipping = new ClipRect();
        noClipping.setWidth( ClipRect.NO_CLIPPING);
        setClipRect(noClipping);
        setTexName(ClipRect.NO_TEXTURE);
        // Return to previous MV matrix
        gl.glMatrixMode(GL10.GL_MODELVIEW);
        gl.glPopMatrix();
    }*/
	
    public void setRenderState(RenderState rs)
    {
        setTexName(rs.getTexName());
        //setTransform(rs.transform);
        setClipRect(rs.getClipRect());
        setAlphaMode(rs.mode);
    }	
    
    @Override
    public void setTexName(int newTexture)
    {
        if (newTexture == getTexName()){
            return;
        }
        
        if (newTexture != ClipRect.NO_TEXTURE)
        {
            // New texture *is* really a texture - change to it.            
            if (getTexName() == ClipRect.NO_TEXTURE){
                gl.glEnable(GL10.GL_TEXTURE_2D);
            }
            gl.glBindTexture(GL10.GL_TEXTURE_2D, getTexName());
        }
        else{
            // New texture is NO_TEXTURE, disable texturing.
        	gl.glDisable(GL10.GL_TEXTURE_2D);
        }
        texName = newTexture;
    }    
    
    @Override
    public void setTransform(int newTransform)
    {
        if (newTransform == transform){
            return;
        }
        transform = newTransform;
        applyTransform();
    }    

    @Override
    public void setClipRect(ClipRect newClipRect)
    {
        if (newClipRect.getWidth() == ClipRect.NO_CLIPPING)
        {
            // Disable clipping
            if (clipRect.getWidth() != ClipRect.NO_CLIPPING)
            {
            	gl.glDisable(GL10.GL_SCISSOR_TEST);
                clipRect.setWidth(ClipRect.NO_CLIPPING);
            }
        }
        else
        {
            // Enable clipping if off
            if (clipRect.getWidth() == ClipRect.NO_CLIPPING)
            {
            	gl.glEnable(GL10.GL_SCISSOR_TEST);
                clipRect = newClipRect;
                gl.glScissor((int)clipRect.getX(), (int)clipRect.getY(), (int)clipRect.getWidth(), (int)clipRect.getHeight());
            }
            // Adjust clipping if necessary
            else if (!(clipRect == newClipRect))
            {
                clipRect = newClipRect;
                gl.glScissor((int)clipRect.getX(), (int)clipRect.getY(), (int)clipRect.getWidth(), (int)clipRect.getHeight());
            }
        }
    }    
    
    public void setAlphaMode(int newMode)
    {
        if (newMode == mode){
            return;
        }
        mode = newMode;
        applyAlphaMode(gl);
    }    

    // The cached values may have been messed with. Reset them again.
    public void enforceAfterUntrustedGL()
    {
        // TODO: Actually, we don't have to worry about anything pushed
        // using glPushAttribs because beginGL/endGL will take care of that.        
        applyTexture(gl);
        applyTransform();
        applyClipRect(gl);
        applyAlphaMode(gl);
    }    
    
}