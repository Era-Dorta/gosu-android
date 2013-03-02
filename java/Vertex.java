package gosu.java;

public class Vertex{
	public float x;
	public float y;
	public Color c;
	
	public Vertex() {};
	
	public Vertex(float x_, float y_, Color c_){
		x = x_;
		y = y_;
		c = c_;
	}
	
	public Vertex(float x_, float y_, long c_){
		x = x_;
		y = y_;
		c = new Color(c_);
	}	
	
	public void set(float x_, float y_, long c_){
		x = x_;
		y = y_;
		c = new Color(c_);		
	}

	public void set(float x_, float y_, Color c_){
		x = x_;
		y = y_;
		c = c_;	
	}
}
