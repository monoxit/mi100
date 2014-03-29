# morsecoder.rb
# Copyright (c) 2014 Masami Yamakawa
# 
# This software is released under the MIT License.
# http://opensource.org/lisenses/mit-license.php

class Mi100
    class Morsecoder
      
      DEFAULT_MORSE_UNIT_MILLIS = 50
      DEFAULT_MORSE_FREQUENCY   = 4000
      DEFAULT_LETTER_SPACE_DOTS = 3
      DEFAULT_WORD_SPACE_DOTS   = 7
      
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
                  
      
      @default_unit = DEFAULT_MORSE_UNIT_MILLIS
      @default_frequency = DEFAULT_MORSE_FREQUENCY
      @default_letter_space = DEFAULT_LETTER_SPACE_DOTS
      @default_word_space = DEFAULT_WORD_SPACE_DOTS
      
      class << self
      
        attr_accessor :default_unit, :default_frequency
        
        def to_morse_from(the_str, frequency = @default_frequency, unit = @default_unit)
          letter_space = @default_letter_space
          word_space = @default_word_space
          morsecode = []

          the_str.to_s.split(//).each do |char|
            code = MORSECODE[char.upcase]
            if code
              code.each do |dots|
                morsecode << {frequency: frequency, duration: unit * dots}
                morsecode << {frequency: false, duration: unit * dots}
              end
              morsecode << {frequency: false, duration: unit * letter_space}
            else
              morsecode << {frequency: false, duration: unit * word_space}
            end
          end
          
          morsecode
        end
        
        def reset
          @default_unit = DEFAULT_MORSE_UNIT_MILLIS
          @default_frequency = DEFAULT_MORSE_FREQUENCY
          @default_letter_space = DEFAULT_LETTER_SPACE_DOTS
          @default_word_space = DEFAULT_WORD_SPACE_DOTS
        end
        
      end
      
      attr_accessor :str, :unit, :frequency
      
      def initialize(str="HELLO WORLD", frequency = Morsecoder.default_frequency, unit=Morsecoder.default_unit)
        @str = str
        @frequency = frequency
        @unit = unit
      end
      
      def to_morse
        frequency = @frequency
        unit = @unit
        Morsecoder.to_morse_from(@str, frequency, unit)
      end
      
      def each
        to_morse.each {|code| yield(code[:frequency], code[:duration])}
      end
    end
end