# morsecoder.rb
# Copyright (c) 2014 Masami Yamakawa
# 
# This software is released under the MIT License.
# http://opensource.org/lisenses/mit-license.php

class Mi100
    class Morsecoder
    
      attr_accessor :morseunit, :morsefrequency
    
      DEFAULT_MORSEUNIT_MILLIS = 50
      DEFAULT_MORSEFREQUENCY = 4000
      MORSECODE = { 
                    "1" => [1,3,3,3,3],
                    "2" => [1,1,3,3,3],
                    "3" => [1,1,1,3,3],
                    "4" => [1,1,1,1,3],
                    "5" => [1,1,1,1,1],
                    "6" => [3,1,1,1,1],
                    "7" => [3,3,1,1,1],
                    "8" => [3,3,3,1,1],
                    "9" => [3,3,3,3,1],
                    "0" => [3,3,3,3,3],
                    "A" => [1,3],
                    "B" => [3,1,1,1],
                    "C" => [3,1,3,1],
                    "D" => [3,1,1],
                    "E" => [1],
                    "F" => [1,1,3,1],
                    "G" => [3,3,1],
                    "H" => [1,1,1,1],
                    "I" => [1,1],
                    "J" => [1,3,3,3],
                    "K" => [1,3,1,1],
                    "L" => [1,3,1,1],
                    "M" => [3,3],
                    "N" => [3,1],
                    "O" => [3,3,3],
                    "P" => [1,3,3,1],
                    "Q" => [3,3,1,3],
                    "R" => [1,3,1],
                    "S" => [1,1,1],
                    "T" => [3],
                    "U" => [1,1,3],
                    "V" => [1,1,1,3],
                    "W" => [1,3,3],
                    "X" => [3,1,1,3],
                    "Y" => [3,1,3,3],
                    "Z" => [3,3,1,1],
                    "." => [1,3,1,3,1,3],
                    "," => [3,3,1,1,3,3],
                    "?" => [1,1,3,3,1,1],
                    "!" => [3,1,3,1,3,3],
                    "-" => [3,1,1,1,1,3],
                    "/" => [3,1,1,3,1],
                    "@" => [1,3,3,1,3,1],
                    "(" => [3,1,3,3,1],
                    ")" => [3,1,3,3,1,3]
                  }
  
      def initialize
        @morseunit = DEFAULT_MORSEUNIT_MILLIS
        @morsefrequency = DEFAULT_MORSEFREQUENCY
      end
    
      def to_morse(str)
        morsecode = []
        str.split(//).each do |char|
          code = MORSECODE[char.upcase]
          if code
            code.each do |dots|
              morsecode << {frequency: @morsefrequency, duration: @morseunit * dots}
              morsecode << {frequency: false, duration: @morseunit * dots}
            end
            morsecode << {frequency: false, duration: morseunit * 3}
          else
            morsecode << {frequency: false, duration: morseunit * 7}
          end
        end
        morsecode
      end
      
    end
end