module Gosu
  
  def self.milliseconds
    tp = Time.now
    start = tp.tv_usec / 1000 + tp.tv_sec * 1000
    res = (tp.tv_usec / 1000 + tp.tv_sec * 1000 - start) & 0x1fffffff
    res
  end
  
end