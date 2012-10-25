module Gosu
  
  def self.milliseconds
    tp = Time.now.to_f
    (tp*1000).to_i
  end
  
end