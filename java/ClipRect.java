package gosu.java;

public class ClipRect {
	public static final long NO_CLIPPING = 0xffffffff;
	public static final int NO_TEXTURE = -1;
	
	private double x, y, width, height;
	
	public ClipRect(){};
	
	public ClipRect(double x_, double y_, double width_, double height_){
		x = x_;
		y = y_;
		width = width_;
		height = height_;
	}
	
	public double getX(){
		return x;
	}
	
	public double getY(){
		return y;
	}	
	
	public double getWidth(){
		return width;
	}
	
	public double getHeight(){
		return height;
	}	
	
	public void setX( double x_){
		x = x_;
	}

	public void setY( double y_){
		y = y_;
	}
	
	public void setWidth( double width_){
		width = width_;
	}
	
	public void setHeight( double height_){
		height = height_;
	}
	
	@Override
	public boolean equals(Object other){
	    if (other == null) return false;
	    if (other == this) return true;
	    if (!(other instanceof ClipRect))return false;
	    ClipRect otherClipRect = (ClipRect)other;
        // No clipping
        return (width == NO_CLIPPING && otherClipRect.getWidth() == NO_CLIPPING) ||
        // Clipping, but same
            (x == otherClipRect.getX() && y == otherClipRect.getY() && 
            width == otherClipRect.getWidth() && height == otherClipRect.getHeight());	    
	}
}

  
