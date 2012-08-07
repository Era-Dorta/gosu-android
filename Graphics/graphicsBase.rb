module Gosu
    module AlphaMode
      #amDefault -> The color's channels will be interpolated. The alpha channel
      #specifies the opacity of the new color, 255 is full opacity.
      
      #amAdd -> The colors' channels will be added. The alpha channel specifies
      #the percentage of the new color's channels that will be added
      #to the old color's channels.   
      
      #amMultiply -> The color's channels will be multiplied with each other.
      AM_DEFAULT, AM_ADD, AM_MULTIPLY = *(0..2) 
      AM_ADDITIVE = AM_ADD   
    end  
end    