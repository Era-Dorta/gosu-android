require 'ruboto/activity'

module JavaImports
  #Opengl classes
  if android.os.Build::VERSION::SDK_INT <= 10
    java_import "gosu.java.GLSurfaceView"
  else
    java_import "android.opengl.GLSurfaceView"
  end

  #Opengl dependencies
  java_import "javax.microedition.khronos.egl.EGL10"
  java_import "javax.microedition.khronos.egl.EGLConfig"
  java_import "javax.microedition.khronos.opengles.GL10"
  
  #Bitmap classes
  java_import "android.graphics.BitmapFactory"
  java_import "android.graphics.Bitmap"
  java_import "android.graphics.Color"
  
  #Objects for textures
  java_import "android.opengl.GLUtils"
  java_import "java.io.InputStream"  
  
  java_import "java.nio.ByteBuffer"
  java_import "java.nio.ByteOrder"
  java_import "java.nio.IntBuffer"
  
  #Event callbacks
  java_import "android.view.MotionEvent"
  java_import "android.view.Window"
  java_import "android.view.WindowManager"
  java_import "android.view.KeyEvent"
  
  #Handles the keyboard
  java_import "android.view.inputmethod.InputMethodManager"
  
  #Fonts
  java_import "android.graphics.Canvas"
  java_import "android.graphics.Paint"
  java_import "android.graphics.Color"
  java_import "android.graphics.Typeface"
  
  #Audio
  java_import "android.media.SoundPool"
  java_import "android.media.AudioManager"  
  java_import "android.media.MediaPlayer" 
  java_import "android.app.Service" 
end  
