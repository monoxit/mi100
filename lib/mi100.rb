require "mi100/version"
require 'timeout'

class Mi100

  DEFAULT_RETRIES     = 3
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
  
  DEFAULT_MOVE_DURATION   = 300
  DEFAULT_SPIN_DURATION   = 140
  DEFAULT_BLINK_DURATION  = 600
  DEFAULT_TONE_DURATION   = 300
  
  DEFAULT_MOVE_DIRECTION  = "FORWARD"
  DEFAULT_SPIN_DIRECTION  = "RIGHT"
  
  FREQUENCY = {DO: 262, RE: 294, MI: 330, FA: 349, SO: 392, LA: 440, SI: 494, HDO: 523}
  
  def initialize(dev)
    retries_left = DEFAULT_RETRIES
    begin
      initialize_serialport dev
    rescue Errno::ENOENT
      puts retries_left
      retries_left -= 1
      retry unless retries_left < 0
      raise
    end
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
    send_command_get_response cmd + "," + duration.to_s
  end
  
  def spin(direction = DEFAULT_SPIN_DIRECTION, duration = DEFAULT_SPIN_DURATION)
    cmd = direction.upcase == "LEFT" ? CMD_SPIN_LEFT : CMD_SPIN_RIGHT
    send_command_get_response cmd + "," + duration.to_s
  end  
  
  def move_forward(duration)
    send_command_get_response CMD_MOVE_FORWARD + "," + duration.to_s
  end
  
  def move_backward(duration)
    send_command_get_response CMD_MOVE_BACKWARD + "," + duration.to_s
  end
  
  def spin_right(duration)
    send_command_get_response CMD_SPIN_RIGHT + "," + duration.to_s
  end
  
  def spin_left(duration)
    send_command_get_response CMD_SPIN_LEFT + "," + duration.to_s
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
  
  def move_forward!(duration)
    sendln CMD_MOVE_FORWARD + "," + duration.to_s
  end
  
  def move_backward!(duration)
    sendln CMD_MOVE_BACKWARD + "," + duration.to_s
  end
  
  def spin_right!(duration)
    sendln CMD_SPIN_RIGHT + "," + duration.to_s
  end
  
  def spin_left!(duration)
    sendln CMD_SPIN_LEFT + "," + duration.to_s
  end
  
  def blink(r = 0, g = 0, b = 0, duration = DEFAULT_BLINK_DURATION)
  
    if r + g + b == 0
      r = rand(100)+1
      g = rand(100)+1
      b = rand(100)+1
    end
    
    r = r <= 100 ? r : 100
    g = g <= 100 ? g : 100
    b = b <= 100 ? b : 100
    
    send_command_get_response CMD_BLINK_LED + "," + r.to_s + "," + g.to_s + "," + b.to_s + "," + duration.to_s
  end

  def stop
    send_command_get_response CMD_STOP
  end
  
  
  def tone(frequency = 0, duration = DEFAULT_TONE_DURATION)
    frequency = rand(4186 - 28) + 28 if frequency < 28
    send_command_get_response CMD_TONE + "," + frequency.to_s + "," + duration.to_s
  end
  

  def sound(pitch = nil, duration = DEFAULT_TONE_DURATION)
    pitch ||= FREQUENCY.keys[rand(FREQUENCY.size)].to_s
    tone FREQUENCY[pitch.upcase.to_sym], duration
    sleep duration.to_f / 1000.0
  end
  
  def good
    tone 440, 100
    sleep 0.1
    tone 880, 100
    sleep 0.1
    tone 1760, 100
    sleep 0.1
  end
  
  def bad
    tone 100, 400
    sleep 0.4
  end
  
  # Private methods
  private
  
  def initialize_serialport(dev)
    require 'serialport'
    @sp = SerialPort.new dev, 38400, 8, 1, SerialPort::NONE
    if is_windows?
      @sp.read_timeout = READ_TIMEOUT
      @sp.write_timeout = WRITE_TIMEOUT
    end
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
    @sp.read_timeout = SHORT_READ_TIMEOUT
    char = @sp.read 1
    while char.length > 0
      char = @sp.read 1
    end
    @sp.read_timeout = READ_TIMEOUT
  end
  
  def receiveln
    if is_windows?
      start_time = Time.now
      str = ""
      while (Time.now - start_time) * 1000.0 < READ_TIMEOUT do
        char = @sp.read 1
        if char.length > 0
          str += char
          break if char == "\n"
        end
      end
    else
      str = @sp.readline
    end
    str
  end

  def is_windows?
    os = RUBY_PLATFORM.split("-")[1]
    os == 'mswin' or os == 'bccwin' or os == 'mingw' or os == 'mingw32'
  end  
end
