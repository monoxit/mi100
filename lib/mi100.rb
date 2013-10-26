require "mi100/version"

class Mi100

  CMD_PING            = "H"
  CMD_GET_POWER_LEVEL = "H"
  CMD_STOP            = "S"
  CMD_MOVE_FORWARD    = "F"
  CMD_MOVE_BACKWORD   = "B"
  CMD_SPIN_RIGHT      = "R"
  CMD_SPIN_LEFT       = "L"
  CMD_BLINK_LED       = "D"
  CMD_TONE            = "T"
  
  DEFAULT_DURATION        = 300
  DEFAULT_MOVE_DIRECTION  = "FORWARD"
  DEFAULT_SPIN_DIRECTION  = "RIGHT"
  
  FREQUENCY = {DO: 262, RE: 294, MI: 330, FA: 349, SO: 392, LA: 440, SI: 494, HDO: 523}
  
  def initialize(dev)
    initialize_serialport dev
  end
  
  def close
    stop
    @sp.close
  end
  
  def ping
    cmd = CMD_PING
    sendln cmd
    acked? cmd
  end
  
  def power
    cmd = CMD_GET_POWER_LEVEL
    sendln cmd
    str = recieveln
    strAry = str.chomp.split(",")
    v = strAry[1].to_i / 1000.0
    v.round 2
  end
  
  def move(direction = DEFAULT_MOVE_DIRECTION, duration = DEFAULT_DURATION)
    cmd = direction.upcase == "BACKWARD" ? CMD_MOVE_BACKWARD : CMD_MOVE_FORWARD
    sendln cmd + "," + duration.to_s
    acked? cmd
  end
  
  def spin(direction = DEFAULT_SPIN_DIRECTION, duration = DEFAULT_DURATION)
    cmd = direction.upcase == "LEFT" ? CMD_SPIN_LEFT : CMD_SPIN_RIGHT
    sendln cmd + "," + duration.to_s
    acked? cmd
  end
  
  def blink(r = 0, g = 0, b = 0, duration = DEFAULT_DURATION * 2)
    if r + g + b == 0
      r = rand(100)+1
      g = rand(100)+1
      b = rand(100)+1
    end
    r = r <= 100 ? r : 100
    g = g <= 100 ? g : 100
    b = b <= 100 ? b : 100
    
    cmd = CMD_BLINK_LED
    sendln cmd + "," + r.to_s + "," + g.to_s + "," + b.to_s + "," + duration.to_s
    acked? cmd
  end
  
  def tone(frequency = 0, duration = DEFAULT_DURATION)
    frequency = rand(4186 - 28) + 28 if frequency < 28
    cmd = CMD_TONE
    sendln cmd + "," + frequency.to_s + "," + duration.to_s
    acked? cmd
  end
  
  def stop
    cmd = CMD_STOP
    sendln cmd
    acked? cmd
  end
  
  def sound(pitch = nil, duration = DEFAULT_DURATION)
    pitch ||= FREQUENCY.keys[rand(FREQUENCY.size)].to_s
    tone FREQUENCY[pitch.upcase.to_sym], duration
    duration+=100
    sleep duration / 1000
  end
  
  def good
    tone 880, 300
    sleep 0.4
    tone 440, 300
    sleep 0.4
  end
  
  def bad
    tone 100, 300
    sleep 0.4
  end
  
  # Private methods
  private
  
  def initialize_serialport(dev)
    require 'serialport'
    @sp = SerialPort.new dev, 38400, 8, 1, SerialPort::NONE
    if is_windows?
      @sp.read_timeout=5000
      @sp.write_timeout=0
    end
  end
  
  def sendln str
    @sp.write str + "\n"
  end
  
  def acked?(cmd)
    str = recieveln
    str[0] == cmd
  end
  
  def recieveln
    stime = Time.now
    str = ""
    while (Time.now - stime) * 1000.0 < @sp.read_timeout do
      c = @sp.read 1
      if c.length > 0
        str += c
        break if c == "\n"
      end
    end
    str
  end

  def is_windows?
    os = RUBY_PLATFORM.split("-")[1]
    os == 'mswin' or os == 'bccwin' or os == 'mingw' or os == 'mingw32'
  end  
end
