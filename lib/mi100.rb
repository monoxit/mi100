# mi100.rb
# Copyright (c) 2014 Masami Yamakawa
#
# This software is released under the MIT License.
# http://opensource.org/lisenses/mit-license.php

require 'mi100/version'
require 'mi100/morsecoder'
require 'timeout'

class Mi100

  DEFAULT_RETRIES     = 5
  READ_TIMEOUT        = 5000
  WRITE_TIMEOUT       = 5000
  SHORT_READ_TIMEOUT  = 1

  CMD_PING            = "H"
  CMD_GET_POWER_LEVEL = "H"
  CMD_STOP            = "S"
  CMD_MOVE_FORWARD    = "F"
  CMD_MOVE_BACKWARD   = "B"
  CMD_SPIN_RIGHT      = "R"
  CMD_SPIN_LEFT       = "L"
  CMD_BLINK_LED       = "D"
  CMD_TONE            = "T"
  CMD_GET_LIGHT       = "P"
  CMD_TURN_RIGHT      = "U"
  CMD_TURN_LEFT       = "A"
  CMD_SET_SPEED       = "W"
  CMD_FREE_RAM        = "M"
  CMD_TURN_LED_RGB    = "V"
  CMD_DRIVE           = "Z"


  DEFAULT_SPEED           = 255
  DEFAULT_MOVE_DURATION   = 300
  DEFAULT_SPIN_DURATION   = 140
  DEFAULT_DRIVE_DURATION  = 50
  DEFAULT_BLINK_DURATION  = 600
  DEFAULT_TONE_DURATION   = 300

  DEFAULT_MOVE_DIRECTION  = "FORWARD"
  DEFAULT_SPIN_DIRECTION  = "RIGHT"

  FREQUENCY = { DO:   262,
                DOS:  277,
                RE:   294,
                RES:  311,
                MI:   330,
                FA:   349,
                FAS:  370,
                SO:   392,
                SOS:  415,
                LA:   440,
                LAS:  466,
                SI:   494,
                HDO:  523,
                HDOS: 554,
                HRE:  587,
                HRES: 622,
                HMI:  659,
                HFA:  698,
                HFAS: 740,
                HSO:  784,
                HSOS: 831,
                HLA:  880,
                HSI:  988,
              }


  def initialize(dev)
    retries_left = DEFAULT_RETRIES
    begin
      initialize_serialport dev
    rescue Errno::ENOENT
      puts "Retry Bluetooth connection: #{retries_left.to_s}"
      retries_left -= 1
      retry unless retries_left < 0
      puts "Bluetooth connection failed."
      raise
    end

    initialize_robo
  end

  def close
    sleep 2
    @sp.close
  end

  def ping
    send_command_get_response CMD_PING
  end

  def power
    response = send_command_get_response CMD_GET_POWER_LEVEL
    voltage = response[1].to_i / 1000.0
    voltage.round 2
  end

  def light
    response = send_command_get_response CMD_GET_LIGHT
    response[1].to_i
  end

  def move(direction = DEFAULT_MOVE_DIRECTION, duration = DEFAULT_MOVE_DURATION)
    cmd = direction.upcase == "BACKWARD" ? CMD_MOVE_BACKWARD : CMD_MOVE_FORWARD
    send_command_get_response "#{cmd},#{duration.to_s}"
  end

  def spin(direction = DEFAULT_SPIN_DIRECTION, duration = DEFAULT_SPIN_DURATION)
    cmd = direction.upcase == "LEFT" ? CMD_SPIN_LEFT : CMD_SPIN_RIGHT
    send_command_get_response "#{cmd},#{duration.to_s}"
  end

  def move_forward(duration)
    send_command_get_response "#{CMD_MOVE_FORWARD},#{duration.to_s}"
  end

  def move_backward(duration)
    send_command_get_response "#{CMD_MOVE_BACKWARD},#{duration.to_s}"
  end

  def spin_right(duration)
    send_command_get_response "#{CMD_SPIN_RIGHT},#{duration.to_s}"
  end

  def spin_left(duration)
    send_command_get_response "#{CMD_SPIN_LEFT},#{duration.to_s}"
  end

  def turn_right(duration)
    send_command_get_response "#{CMD_TURN_RIGHT},#{duration.to_s}"
  end

  def turn_left(duration)
    send_command_get_response "#{CMD_TURN_LEFT},#{duration.to_s}"
  end

  def movef(duration = DEFAULT_MOVE_DURATION)
    move_forward duration
  end

  def moveb(duration = DEFAULT_MOVE_DURATION)
    move_backward duration
  end

  def spinr(duration = DEFAULT_SPIN_DURATION)
    spin_right duration
  end

  def spinl(duration = DEFAULT_SPIN_DURATION)
    spin_left duration
  end

  def drive(right_speed, left_speed, duration = @drive_duration)
    send_command_get_response "#{CMD_DRIVE},#{right_speed.to_s},#{left_speed.to_s},#{duration.to_s}"
  end

  def drive_right(turn_speed, speed = @speed, duration = @drive_duration)
    send_command_get_response "#{CMD_DRIVE},#{speed.to_s},#{(speed + turn_speed).to_s},#{duration.to_s}"
  end

  def drive_left(turn_speed, speed = @speed, duration = @drive_duration)
    send_command_get_response "#{CMD_DRIVE},#{(speed + turn_speed).to_s},#{speed.to_s},#{duration.to_s}"
  end

  def move_forward!(duration)
    sendln "#{CMD_MOVE_FORWARD},#{duration.to_s}"
  end

  def move_backward!(duration)
    sendln "#{CMD_MOVE_BACKWARD},#{duration.to_s}"
  end

  def spin_right!(duration)
    sendln "#{CMD_SPIN_RIGHT},#{duration.to_s}"
  end

  def spin_left!(duration)
    sendln "#{CMD_SPIN_LEFT},#{duration.to_s}"
  end

  def turn_right!(duration)
    sendln "#{CMD_TURN_RIGHT},#{duration.to_s}"
  end

  def turn_left!(duration)
    sendln "#{CMD_TURN_LEFT},#{duration.to_s}"
  end

  def drive!(right_speed, left_speed, duration = @drive_duration)
    sendln "#{CMD_DRIVE},#{right_speed.to_s},#{left_speed.to_s},#{duration.to_s}"
  end

  def drive_right!(turn_speed, speed = @speed, duration = @drive_duration)
    sendln "#{CMD_DRIVE},#{speed.to_s},#{(speed + turn_speed).to_s},#{duration.to_s}"
  end

  def drive_left!(turn_speed, speed = @speed, duration = @drive_duration)
    sendln "#{CMD_DRIVE},#{(speed + turn_speed).to_s},#{speed.to_s},#{duration.to_s}"
  end

  def speed(pwm_value = DEFAULT_SPEED)
    @speed = pwm_value
    send_command_get_response "#{CMD_SET_SPEED},#{pwm_value.to_s}"
  end

  def drive_duration(duration = DEFAULT_DRIVE_DURATION)
    @drive_duration = duration
  end

  def free_ram
    send_command_get_response "#{CMD_FREE_RAM}"
  end

  def blink(r = nil, g = nil, b = nil, duration = DEFAULT_BLINK_DURATION)
    r ||= rand(100)+1
    g ||= rand(100)+1
    b ||= rand(100)+1
    r = 100 if r > 100
    g = 100 if g > 100
    b = 100 if b > 100
    send_command_get_response "#{CMD_BLINK_LED},#{r.to_s},#{g.to_s},#{b.to_s},#{duration.to_s}"
  end

  def turn_led(r = 0, g = 0, b = 0)
    send_command_get_response "#{CMD_TURN_LED_RGB},#{r.to_s},#{g.to_s},#{b.to_s}"
  end

  def led_on
    turn_led(100,100,100)
  end
  
  def led_off
    turn_led(0,0,0)
  end
  
  def stop
    send_command_get_response CMD_STOP
  end

  def tone(frequency = nil, duration = DEFAULT_TONE_DURATION)
    frequency ||= rand(4186 - 28) + 28
    frequency = 4186 if frequency > 4186
    frequency = 28 if frequency < 28
    send_command_get_response "#{CMD_TONE},#{frequency.to_s},#{duration.to_s}"
  end

  def sound(pitch = "?", duration = DEFAULT_TONE_DURATION)

    if pitch.instance_of?(String)
      pitch = FREQUENCY.keys[rand(FREQUENCY.size)].to_s if pitch == "?"
      frequency = FREQUENCY[pitch.upcase.to_sym]
    else
      frequency = pitch
    end

    tone frequency, duration if frequency
    sleep duration.to_f / 1000.0
  end

  def good
    freqs = [440,880,1760]
    duration = 100.0
    freqs.each do |freq|
      tone freq, duration
      sleep duration / 1000.0
    end
  end

  def bad
    duration = 400.0
    freq = 100
    tone freq, duration
    sleep duration / 1000.0
  end

  def talk(str)
    morsecoder = Morsecoder.new str
    morsecoder.each {|frequency, duration| sound(frequency,duration)}
  end

  def morse_frequency
    Morsecoder.default_frequency
  end

  def morse_frequency=(frequency)
    Morsecoder.default_frequency = frequency
  end

  def morse_unit
    Morsecoder.default_unit
  end

  def morse_unit=(millisec)
    Morsecoder.default_unit = millisec
  end

  # Private methods
  private

  def initialize_serialport(dev)
    require 'rubyserial'
    @sp = Serial.new dev, 9600
  end

  def initialize_robo
    self.speed DEFAULT_SPEED
    self.drive_duration DEFAULT_DRIVE_DURATION
    self.turn_led 0,0,0
  end

  def send_command_get_response(cmd = CMD_PING)
    empty_receive_buffer
    sendln cmd
    received_line = receiveln

    begin
      timeout(READ_TIMEOUT/1000) do
        received_line = receiveln until received_line[0] == cmd[0]
      end
    rescue
      return nil
    end
    received_line.chomp.split(",")
  end

  def sendln str
    @sp.write str + "\n"
  end

  def empty_receive_buffer
    begin
      char = @sp.getbyte
    end while char && char.length > 0
  end

  def receiveln
    @sp.gets
  end

end
