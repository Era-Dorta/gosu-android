require 'ruboto/activity'
require 'ruboto/generate'

module JavaImports
  java_import "android.opengl.GLSurfaceView"
  
  java_import "javax.microedition.khronos.egl.EGL10"
  java_import "javax.microedition.khronos.egl.EGLConfig"
  java_import "javax.microedition.khronos.opengles.GL10"
  
  java_import "java.nio.ByteBuffer"
  java_import "java.nio.ByteOrder"
  java_import "java.nio.IntBuffer"
  java_import "android.view.MotionEvent"
  java_import "android.view.Window"
  java_import "android.view.WindowManager"
end  