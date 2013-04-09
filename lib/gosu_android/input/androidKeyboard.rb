require 'gosu_android/requires'

class AndroidKeyboard < JavaImports::InputMethodService 
  include JavaImports::KeyboardView::OnKeyboardActionListener
  attr_accessor :gosu_window
  
	def onKey(primaryCode, keyCodes)
	  puts "onKey(primaryCode #{primaryCode}, keyCodes) #{keyCodes}" 
    return true
  end

	def onPress(primaryCode) 
	  puts" onPress(primaryCode) #{primaryCode} "
    return true
  end

	def onRelease(primaryCode) 
	  puts"onRelease(primaryCode) #{primaryCode}" 
    return true
  end

	def onText(text) 
	  puts "onText(text) #{text}"
    return true
  end

	def swipeDown 
	  puts "swipeDown"
    return true
  end

	def swipeLeft 
	  puts "swipeLeft"
    return true
  end

	def swipeRight 
	  puts "swipeRight"
    return true
  end

	def swipeUp 
	  puts "swipeUp"
    return true
  end
  
  def onKeyDown( keyCode, event )
    puts "onKeyDown( keyCode, event ) #{keyCode } #{event}"
    return true
  end
  
  def onKeyUp( keyCode, event )
    puts "onKeyUp( keyCode, event ) #{keyCode} #{event}"
    return true
  end
    
end
