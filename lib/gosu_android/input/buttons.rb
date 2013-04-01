require 'gosu_android/requires'


module Gosu
  Kb0 = JavaImports::KeyEvent::KEYCODE_0
  Kb1 = JavaImports::KeyEvent::KEYCODE_1
  Kb2 = JavaImports::KeyEvent::KEYCODE_2
  Kb3 = JavaImports::KeyEvent::KEYCODE_3
  Kb4 = JavaImports::KeyEvent::KEYCODE_4
  Kb5 = JavaImports::KeyEvent::KEYCODE_5
  Kb6 = JavaImports::KeyEvent::KEYCODE_6
  Kb7 = JavaImports::KeyEvent::KEYCODE_7
  Kb8 = JavaImports::KeyEvent::KEYCODE_8
  Kb9 = JavaImports::KeyEvent::KEYCODE_9
  KbA = JavaImports::KeyEvent::KEYCODE_A
  KbB = JavaImports::KeyEvent::KEYCODE_B
  KbC = JavaImports::KeyEvent::KEYCODE_C
  KbD = JavaImports::KeyEvent::KEYCODE_D
  KbE = JavaImports::KeyEvent::KEYCODE_E
  KbF = JavaImports::KeyEvent::KEYCODE_F
  KbG = JavaImports::KeyEvent::KEYCODE_G
  KbH = JavaImports::KeyEvent::KEYCODE_H
  KbI = JavaImports::KeyEvent::KEYCODE_I
  KbJ = JavaImports::KeyEvent::KEYCODE_J
  KbK = JavaImports::KeyEvent::KEYCODE_K
  KbL = JavaImports::KeyEvent::KEYCODE_L
  KbM = JavaImports::KeyEvent::KEYCODE_M
  KbN = JavaImports::KeyEvent::KEYCODE_N
  KbO = JavaImports::KeyEvent::KEYCODE_O
  KbP = JavaImports::KeyEvent::KEYCODE_P
  KbQ = JavaImports::KeyEvent::KEYCODE_Q
  KbR = JavaImports::KeyEvent::KEYCODE_R
  KbS = JavaImports::KeyEvent::KEYCODE_S
  KbT = JavaImports::KeyEvent::KEYCODE_T
  KbU = JavaImports::KeyEvent::KEYCODE_U
  KbV = JavaImports::KeyEvent::KEYCODE_V
  KbW = JavaImports::KeyEvent::KEYCODE_W
  KbX = JavaImports::KeyEvent::KEYCODE_X
  KbY = JavaImports::KeyEvent::KEYCODE_Y
  KbZ = JavaImports::KeyEvent::KEYCODE_Z
  KbBackspace = JavaImports::KeyEvent::KEYCODE_DEL
  KbDelete = JavaImports::KeyEvent::KEYCODE_DEL
  KbDown = JavaImports::KeyEvent::KEYCODE_DPAD_DOWN
  # On Numpad
  KbHome = JavaImports::KeyEvent::KEYCODE_HOME
  KbLeft = JavaImports::KeyEvent::KEYCODE_DPAD_LEFT
  KbLeftAlt = JavaImports::KeyEvent::KEYCODE_ALT_LEFT
  KbLeftShift = JavaImports::KeyEvent::KEYCODE_SHIFT_LEFT
  KbPageDown = JavaImports::KeyEvent::KEYCODE_PAGE_DOWN
  KbPageUp = JavaImports::KeyEvent::KEYCODE_PAGE_UP
  # Above the right shift key
  KbReturn = JavaImports::KeyEvent::KEYCODE_ENTER
  KbRight = JavaImports::KeyEvent::KEYCODE_DPAD_RIGHT
  KbRightAlt = JavaImports::KeyEvent::KEYCODE_ALT_RIGHT
  #KbRightControl = JavaImports::KeyEvent::KEYCODE_CTRL_RIGHT
  KbRightShift = JavaImports::KeyEvent::KEYCODE_SHIFT_RIGHT
  KbSpace = JavaImports::KeyEvent::KEYCODE_SPACE
  KbTab = JavaImports::KeyEvent::KEYCODE_TAB
  KbUp = JavaImports::KeyEvent::KEYCODE_DPAD_UP
  #TODO Fix mouse buttons, Mouse access to motion event
  #MsLeft = JavaImports::MotionEvent::BUTTON_PRIMARY
  #MsMiddle = JavaImports::MotionEvent::BUTTON_TERTIARY
  #MsRight = JavaImports::MotionEvent::BUTTON_SECONDARY
  #TODO Axis wheel is not right
  #MsWheelDown = JavaImports::MotionEvent::AXIS_WHEEL
  #MsWheelUp = JavaImports::MotionEvent::AXIS_WHEEL
  NoButton = 0xffffffff
  #Not Supported GpDown, GpLeft, GpRight, GpUp

  #Load supported buttons on android above 3.0.0
  if android.os.Build::VERSION::SDK_INT >= 11
    KbEnd = JavaImports::KeyEvent::KEYCODE_MOVE_END
    # On Numpad
    KbEnter = JavaImports::KeyEvent::KEYCODE_NUMPAD_ENTER
    KbEscape = JavaImports::KeyEvent::KEYCODE_ESCAPE
    KbF1 = JavaImports::KeyEvent::KEYCODE_F1
    KbF10 = JavaImports::KeyEvent::KEYCODE_F10
    KbF11 = JavaImports::KeyEvent::KEYCODE_F11
    KbF12 = JavaImports::KeyEvent::KEYCODE_F12
    KbF2 = JavaImports::KeyEvent::KEYCODE_F2
    KbF3 = JavaImports::KeyEvent::KEYCODE_F3
    KbF4 = JavaImports::KeyEvent::KEYCODE_F4
    KbF5 = JavaImports::KeyEvent::KEYCODE_F5
    KbF6 = JavaImports::KeyEvent::KEYCODE_F6
    KbF7 = JavaImports::KeyEvent::KEYCODE_F7
    KbF8 = JavaImports::KeyEvent::KEYCODE_F8
    KbF9 = JavaImports::KeyEvent::KEYCODE_F9
    KbInsert = JavaImports::KeyEvent::KEYCODE_INSERT
    KbLeftControl = JavaImports::KeyEvent::KEYCODE_CTRL_LEFT
    KbNumpad0 = JavaImports::KeyEvent::KEYCODE_NUMPAD_0
    KbNumpad1 = JavaImports::KeyEvent::KEYCODE_NUMPAD_1
    KbNumpad2 = JavaImports::KeyEvent::KEYCODE_NUMPAD_2
    KbNumpad3 = JavaImports::KeyEvent::KEYCODE_NUMPAD_3
    KbNumpad4 = JavaImports::KeyEvent::KEYCODE_NUMPAD_4
    KbNumpad5 = JavaImports::KeyEvent::KEYCODE_NUMPAD_5
    KbNumpad6 = JavaImports::KeyEvent::KEYCODE_NUMPAD_6
    KbNumpad7 = JavaImports::KeyEvent::KEYCODE_NUMPAD_7
    KbNumpad8 = JavaImports::KeyEvent::KEYCODE_NUMPAD_8
    KbNumpad9 = JavaImports::KeyEvent::KEYCODE_NUMPAD_9
    KbNumpadAdd = JavaImports::KeyEvent::KEYCODE_NUMPAD_ADD
    KbNumpadDivide = JavaImports::KeyEvent::KEYCODE_NUMPAD_DIVIDE
    KbNumpadMultiply = JavaImports::KeyEvent::KEYCODE_NUMPAD_MULTIPLY
    KbNumpadSubtract = JavaImports::KeyEvent::KEYCODE_NUMPAD_SUBTRACT
    # Above the right shift key
    KbRightControl = JavaImports::KeyEvent::KEYCODE_CTRL_RIGHT
  end

  #Load supported buttons on android above 4.0.0
  if android.os.Build::VERSION::SDK_INT >= 15
    # Game pad
    GpButton0 = JavaImports::KeyEvent::KEYCODE_BUTTON_1
    GpButton1 = JavaImports::KeyEvent::KEYCODE_BUTTON_2
    GpButton10 = JavaImports::KeyEvent::KEYCODE_BUTTON_11
    GpButton11 = JavaImports::KeyEvent::KEYCODE_BUTTON_12
    GpButton12 = JavaImports::KeyEvent::KEYCODE_BUTTON_13
    GpButton13 = JavaImports::KeyEvent::KEYCODE_BUTTON_14
    GpButton14 = JavaImports::KeyEvent::KEYCODE_BUTTON_15
    GpButton15 = JavaImports::KeyEvent::KEYCODE_BUTTON_16
    GpButton2 = JavaImports::KeyEvent::KEYCODE_BUTTON_3
    GpButton3 = JavaImports::KeyEvent::KEYCODE_BUTTON_4
    GpButton4 = JavaImports::KeyEvent::KEYCODE_BUTTON_5
    GpButton5 = JavaImports::KeyEvent::KEYCODE_BUTTON_6
    GpButton6 = JavaImports::KeyEvent::KEYCODE_BUTTON_7
    GpButton7 = JavaImports::KeyEvent::KEYCODE_BUTTON_8
    GpButton8 = JavaImports::KeyEvent::KEYCODE_BUTTON_9
    GpButton9 = JavaImports::KeyEvent::KEYCODE_BUTTON_10
  end
end
