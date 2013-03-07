package gosu.java;

import android.graphics.BitmapFactory;
import android.content.Context;
import java.nio.ByteBuffer;
import java.nio.IntBuffer;
import java.nio.ByteOrder;
import java.util.ArrayList;

public class Bitmap {
    private int w;
    private int h;
    private ArrayList<Color> pixels = new ArrayList<Color>();
            
    public Bitmap(){
        w = 0;
        h = 0;
        pixels = null;
    }
      
    public Bitmap( Context context, String name){
        android.graphics.Bitmap bitmap = BitmapFactory.decodeFile(name);
        if(bitmap == null){
            throw new RuntimeException("Could not load image " + name);
        }          
        w = bitmap.getWidth();
        h = bitmap.getHeight();
        int[] pArray = new int[w*h];
        bitmap.getPixels(pArray, 0, w, 0, 0, w, h);   
        pixels.ensureCapacity(pArray.length); 
        Color j;
        for(int i = 0; i < pArray.length; i++){
        	j = new Color(pArray[i]);
            pixels.add(j);
        }
        bitmap.recycle();          
    }
    
    public Bitmap( Context context, int id){
    	android.graphics.Bitmap bitmap;
    	bitmap = BitmapFactory.decodeResource( context.getResources(), id);
        w = bitmap.getWidth();
        h = bitmap.getHeight();
        int pArray[] = new int[w*h];
        bitmap.getPixels(pArray, 0, w, 0, 0, w, h);   
        pixels.ensureCapacity(pArray.length); 
        for(int i = 0; i < pArray.length; i++){
            pixels.add(new Color(pArray[i]));
        }
        bitmap.recycle();        	
    }

    public Bitmap( android.graphics.Bitmap bmp ){
        android.graphics.Bitmap bitmap = bmp;    
        w = bitmap.getWidth();
        h = bitmap.getHeight();
        int pArray[] = new int[w*h];
        bitmap.getPixels(pArray, 0, w, 0, 0, w, h);   
        pixels.ensureCapacity(pArray.length); 
        for(int i = 0; i < pArray.length; i++){
            pixels.add(new Color(pArray[i]));
        }
        bitmap.recycle();         
    }
    
    public Bitmap( int w_, int h_ ){
        Color c = new Color(0,0,0);
        w = w_;
        h = h_;
        pixels.ensureCapacity(w*h); 
        for(int i = 0; i < w*h; i++){
            pixels.add(c);
        }
    }

    public Bitmap( int w_, int h_, Color c ){
        w = w_;
        h = h_;
        pixels.ensureCapacity(w*h); 
        for(int i = 0; i < w*h; i++){
            pixels.add(c);
        }
    }
    
    public int getWidth(){
        return w;
    }
    
    public int getHeight(){
        return h;
    }
   
    public void swap( Bitmap other ){
        pixels = other.pixels;
        w = other.w;
        h = other.h;       
    }
    
    public void resize( int width, int height ){
	    resize( width, height, new Color(0x00000000) );   
    }

    public void resize( int width, int height, Color c ){
	    if(width == w && height == h){
	    	return;
	    }    
	    Bitmap temp = new Bitmap(width, height, c);
	    temp.insert(this, 0, 0);
	    swap(temp);    
    }
    public Color getPixel(int x, int y){
        return pixels.get(y*w + x);
    }
    
    public void setPixel( int x, int y, Color c ){
        pixels.set(y*w + x,c);
    }
            
    public void insert( Bitmap source, int x, int y ){
    	insert(source, x, y, 0, 0, source.getWidth(), source.getHeight());      
    } 
    
    public void insert( Bitmap source, int x, int y, int srcX,
      int srcY, int srcWidth, int srcHeight){
      if(x < 0){
        int clip_left = -x;
        if(clip_left >= srcWidth){
            return;
        }
        srcX += clip_left;
        srcWidth -= clip_left;
        x = 0;             
      }
  
      if(y < 0){
        int clipTop = -y;
  
        if(clipTop >= srcHeight){
            return;
        }
        srcY += clipTop;
        srcHeight -= clipTop;
        y = 0;
     }
  
      if(x + srcWidth > w){
        if(x >= w){
            return;
        }
        srcWidth = w - x;
      }
  
      if(y + srcHeight > h){
        if(y >= h){
            return;
        }
        srcHeight = h - y;
     }
  
    for (int relY = 0; relY < srcHeight; ++relY)
        for (int relX = 0; relX < srcWidth; ++relX)
            setPixel(x + relX, y + relY,
                source.getPixel(srcX + relX, srcY + relY));        
    }

    public Color[] data(){
        return (Color [])pixels.toArray() ;
    }
    
    
    public IntBuffer dataJava(){

      int pAux[] = new int[w*h];
      for(int i = 0; i < pAux.length;i++){
          pAux[i] = pixels.get(i).gl();
      }

      ByteBuffer pbb = ByteBuffer.allocateDirect(pAux.length*4);
      pbb.order(ByteOrder.nativeOrder());
      IntBuffer pixelBuffer;
      pixelBuffer = pbb.asIntBuffer();
      pixelBuffer.put(pAux);
      pixelBuffer.position(0);
      return pixelBuffer;       
    }

    public void replace( Color what, Color with){
        for(int i = 0; i < pixels.size(); i++){
            if( pixels.get(i) == what ){
                pixels.set(i,with);
            }
        }         
    }   
}