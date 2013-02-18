package gosu.java;

  public class Color{

	public final static int GL_FORMAT = 0x1908;
	
    private final static int RED_OFFSET = 0;
    private final static int GREEN_OFFSET = 8;
    private final static int BLUE_OFFSET = 16;
    private final static int ALPHA_OFFSET = 24; 
    
    
    private int rep;
    
    private int RGBAtoColor( int alpha, int red, int green, int blue ) { 
		return( (alpha << 24) | red | (green << 8) | (blue << 16) );
	} 
    
    public Color(){
    	rep = 0;
    }
    
    public Color( long argb ){
    	rep = RGBAtoColor( (int)((argb >> 24) & 0xff), (int)((argb >> 16) & 0xff), 
                (int)((argb >>  8) & 0xff), (int)((argb) & 0xff) );
    }
    
    public Color( int red, int green, int blue ){
        rep = RGBAtoColor(0xff, red, green, blue);
    }

    public Color( int alpha, int red, int green, int blue ){
        rep = RGBAtoColor(alpha, red, green, blue);
    }
    
    //Return internal representation of the color
    public int gl(){
      return rep;
    }
    
    public int getRed(){
      return (rep >> RED_OFFSET)&0x000000FF;
    }

    public int getGreen(){
      return (rep >> GREEN_OFFSET)&0x000000FF;
    }

    public int getBlue(){
      return (rep >> BLUE_OFFSET)&0x000000FF;
    }

    public int getAlpha(){
      return (rep >> ALPHA_OFFSET)&0x000000FF;
    }

    public void setRed( int value ){
        rep &= ~(0xff << RED_OFFSET);
        rep |= value << RED_OFFSET;
    }

    public void setGreen(int value){
        rep &= ~(0xff << GREEN_OFFSET);
        rep |= value << GREEN_OFFSET;
    }
    
    public void  setBlue( int value ){
        rep &= ~(0xff << BLUE_OFFSET);
        rep |= value << BLUE_OFFSET;
    }

    public void setAlpha( int value ){
        rep &= ~(0xff << ALPHA_OFFSET);
        rep |= value << ALPHA_OFFSET;
    }    
    
    public boolean equals(Color other){   
      return(rep == other.gl());
    } 
}
