module Gosu
  #amDefault -> The color's channels will be interpolated. The alpha channel
  #specifies the opacity of the new color, 255 is full opacity.
  
  #amAdd -> The colors' channels will be added. The alpha channel specifies
  #the percentage of the new color's channels that will be added
  #to the old color's channels.   
  
  #amMultiply -> The color's channels will be multiplied with each other.
  AM_MODES = { :default => 0, :add => 1, :additive => 1, :multiply => 2 }
  
  FF_BOLD         = 1
  FF_ITALIC       = 2
  FF_UNDERLINE    = 4
  FF_COMBINATIONS = 8
  
  TA_LEFT, TA_RIGHT, TA_CENTER, TA_JUSTIFY = *(0..3)
  
  #Flags that affect the tileability of an image 
  BF_SMOOTH = 0
  BF_TILEABLE_LEFT = 1
  BF_TILEABLE_TOP = 2
  BF_TILEABLE_RIGHT = 4
  BF_TILEABLE_BOTTOM = 8
  BF_TILEABLE = BF_TILEABLE_LEFT | BF_TILEABLE_TOP | BF_TILEABLE_RIGHT | BF_TILEABLE_BOTTOM
end    