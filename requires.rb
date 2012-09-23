require 'ruboto/activity'
require 'ruboto/generate'

module JavaImports
  #Opengl classes
  java_import "android.opengl.GLSurfaceView"
  
  java_import "javax.microedition.khronos.egl.EGL10"
  java_import "javax.microedition.khronos.egl.EGLConfig"
  java_import "javax.microedition.khronos.opengles.GL10"
  
  #Bitmap classes
  java_import "android.graphics.BitmapFactory"
  java_import "android.graphics.Bitmap"
  #Objects for textures
  java_import "android.opengl.GLUtils"
  java_import "java.io.InputStream"  
  
  java_import "java.nio.ByteBuffer"
  java_import "java.nio.ByteOrder"
  java_import "java.nio.IntBuffer"
  java_import "android.view.MotionEvent"
  java_import "android.view.Window"
  java_import "android.view.WindowManager"
  java_import "android.view.KeyEvent"
end  