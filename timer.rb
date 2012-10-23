module Gosu
  
  def self.milliseconds
    tp = Time.now
    start = tp.tv_usec / 1000.0 + tp.tv_sec * 1000.0
    res = (tp.tv_usec / 1000.0 + tp.tv_sec * 1000.0 - start) & 0x1fffffff
    res
  end
  
end