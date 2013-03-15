package gosu.java;

import java.util.ArrayList;

import javax.microedition.khronos.opengles.GL10;

public class DrawOpPool{
	   
	private int size;
	private int capacity;
	private int addOffset;
	private GL10 gl;
	private ArrayList<DrawOp> opPool = new ArrayList<DrawOp>();
	
    public DrawOpPool( GL10 gl_, int capacity_ ){
    	gl = gl_;
    	size = 0;
    	capacity = capacity_;
    	addOffset = 50;
    	opPool.ensureCapacity(capacity); 
    	DrawOp op;
		for(int i = 0; i < capacity; i++){
			op = new DrawOp(gl);
			op.vertices[0] = new Vertex();
			op.vertices[1] = new Vertex();
			op.vertices[2] = new Vertex();
			op.vertices[3] = new Vertex();
			opPool.add(op);
		}    	
    }
    
    public DrawOp newDrawOp(){    	
    	size += 1;
    	if(size ==  capacity){
    		DrawOp op;
    		opPool.ensureCapacity(capacity + addOffset); 
    		for(int i = 0; i < addOffset; i++){
    			op = new DrawOp(gl);
    			op.vertices[0] = new Vertex();
    			op.vertices[1] = new Vertex();
    			op.vertices[2] = new Vertex();
    			op.vertices[3] = new Vertex();
    			opPool.add(op);
    		}
    		capacity = capacity + addOffset;
    	}
    	return opPool.get(size - 1);
    }    
    
    public void freeDrawOp(){    
    	if(size == 0){
    		return;
    	}    	
    	size -= 1;
    	opPool.get(size).getRenderState().reset();
    }    
    
    public void clearPool(){    
    	for(int i = 0; i < size; i++){
    		opPool.get(i).getRenderState().reset();
    	}
    	size = 0;
    }     
}