require 'spec_helper'

describe Mi100 do

  it 'should have a version number' do
    expect(Mi100::VERSION).not_to be nil
  end

  before :each do
    Mi100.any_instance.stub(:initialize_serialport)
    Mi100.any_instance.stub(:initialize_robo)
  end

  it 'should create the instance' do
    mi100 = Mi100.new "COM5"
    expect(mi100).to be_a Mi100
  end

  it 'should send "H" on :ping' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_PING,1234])
    mi100 = Mi100.new "COM5"
    expect(mi100.ping).to eq(["H",1234])
    expect(mi100).to have_received(:send_command_get_response).with("H")
  end

  it 'should send "H" and return rounded power level on :power' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_GET_POWER_LEVEL,1188])
    mi100 = Mi100.new "COM5"
    expect(mi100.power).to eq(1.19)
    expect(mi100).to have_received(:send_command_get_response).with("H")
  end

  it 'should send "P" and get light level on :light' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_GET_LIGHT,1188])
    mi100 = Mi100.new "COM5"
    expect(mi100.light).to eq(1188)
    expect(mi100).to have_received(:send_command_get_response).with("P")
  end

  it 'should send "F,duration" on move "FORWARD"' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_MOVE_FORWARD,1234])
    mi100 = Mi100.new "COM5"
    expect(mi100.move "FORWARD").to eq(["F",1234])
    expect(mi100).to have_received(:send_command_get_response).with("F,300")
  end

  it 'should send "B,duration" on move "BACKWARD"' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_MOVE_BACKWARD,1234])
    mi100 = Mi100.new "COM5"
    expect(mi100.move "BACKWARD").to eq(["B",1234])
    expect(mi100).to have_received(:send_command_get_response).with("B,300")
  end

  it 'should send "R,140" on spin "RIGHT"' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_SPIN_RIGHT,1234])
    mi100 = Mi100.new "COM5"
    expect(mi100.spin "RIGHT").to eq(["R",1234])
    expect(mi100).to have_received(:send_command_get_response).with("R,140")
  end

  it 'should send "L,140" on spin "LEFT"' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_SPIN_LEFT,1234])
    mi100 = Mi100.new "COM5"
    expect(mi100.spin "LEFT").to eq(["L",1234])
    expect(mi100).to have_received(:send_command_get_response).with("L,140")
  end

  it 'should send "F,duration" on move_forward duration' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_MOVE_FORWARD,1234])
    mi100 = Mi100.new "COM5"
    expect(mi100.move_forward 500).to eq(["F",1234])
    expect(mi100).to have_received(:send_command_get_response).with("F,500")
  end

  it 'should send "B,duration" move_backward duration' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_MOVE_BACKWARD,1234])
    mi100 = Mi100.new "COM5"
    expect(mi100.move_backward 500).to eq(["B",1234])
    expect(mi100).to have_received(:send_command_get_response).with("B,500")
  end

  it 'should send "R,duration" spin_right duration' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_SPIN_RIGHT,1234])
    mi100 = Mi100.new "COM5"
    expect(mi100.spin_right 500).to eq(["R",1234])
    expect(mi100).to have_received(:send_command_get_response).with("R,500")
  end

  it 'should send "L,duration" on spin_left duration' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_SPIN_LEFT,1234])
    mi100 = Mi100.new "COM5"
    expect(mi100.spin_left 500).to eq(["L",1234])
    expect(mi100).to have_received(:send_command_get_response).with("L,500")
  end

  it 'should send "U,duration" on turn_right duration' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_TURN_RIGHT,123])
    mi100 = Mi100.new "COM5"
    expect(mi100.turn_right 500).to eq(["U",123])
    expect(mi100).to have_received(:send_command_get_response).with("U,500")
  end

  it 'should send "A,duration" on turn_left duration' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_TURN_LEFT,123])
    mi100 = Mi100.new "COM5"
    expect(mi100.turn_left 500).to eq(["A",123])
    expect(mi100).to have_received(:send_command_get_response).with("A,500")
  end

  it 'should send "F, 300" on movef' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_MOVE_FORWARD,1234])
    mi100 = Mi100.new "COM5"
    expect(mi100.movef).to eq(["F",1234])
    expect(mi100).to have_received(:send_command_get_response).with("F,300")
  end

  it 'should send "B,300" on moveb' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_MOVE_BACKWARD,1234])
    mi100 = Mi100.new "COM5"
    expect(mi100.moveb).to eq(["B",1234])
    expect(mi100).to have_received(:send_command_get_response).with("B,300")
  end

  it 'should send "R,140" spinr' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_SPIN_RIGHT,1234])
    mi100 = Mi100.new "COM5"
    expect(mi100.spinr).to eq(["R",1234])
    expect(mi100).to have_received(:send_command_get_response).with("R,140")
  end

  it 'should send "L,140" on spinl' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_SPIN_LEFT,1234])
    mi100 = Mi100.new "COM5"
    expect(mi100.spinl).to eq(["L",1234])
    expect(mi100).to have_received(:send_command_get_response).with("L,140")
  end

  it 'should send "Z,right_speed,left_speed,duration" on drive right_speed, left_speed, duration' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_DRIVE,1234])
    mi100 = Mi100.new "COM5"
    expect(mi100.drive 123, 234, 56).to eq(["Z",1234])
    expect(mi100).to have_received(:send_command_get_response).with("Z,123,234,56")
  end

  it 'should send "Z,right_speed,left_speed,duration" on drive right_speed, left_speed' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_DRIVE,1234])
    mi100 = Mi100.new "COM5"
    mi100.instance_variable_set(:@drive_duration, Mi100::DEFAULT_DRIVE_DURATION)
    expect(mi100.drive 123, 234).to eq(["Z",1234])
    expect(mi100).to have_received(:send_command_get_response).with("Z,123,234,50")
  end

  it 'should send "Z,right_speed,left_speed,duration" on drive_right turn_speed, speed, duration' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_DRIVE,1234])
    mi100 = Mi100.new "COM5"
    expect(mi100.drive_right 111, 123, 56).to eq(["Z",1234])
    expect(mi100).to have_received(:send_command_get_response).with("Z,123,234,56")
  end

  it 'should send "Z,right_speed,left_speed,duration" on drive_right turn_speed' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_DRIVE,1234])
    mi100 = Mi100.new "COM5"
    mi100.instance_variable_set(:@speed, 123)
    mi100.instance_variable_set(:@drive_duration, Mi100::DEFAULT_DRIVE_DURATION)
    expect(mi100.drive_right 111).to eq(["Z",1234])
    expect(mi100).to have_received(:send_command_get_response).with("Z,123,234,50")
  end

  it 'should send "Z,right_speed,left_speed,duration" on drive_left turn_speed, speed, duration' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_DRIVE,1234])
    mi100 = Mi100.new "COM5"
    expect(mi100.drive_left 111, 123, 56).to eq(["Z",1234])
    expect(mi100).to have_received(:send_command_get_response).with("Z,234,123,56")
  end

  it 'should send "Z,right_speed,left_speed,duration" on drive_left turn_speed' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_DRIVE,1234])
    mi100 = Mi100.new "COM5"
    mi100.instance_variable_set(:@speed, 123)
    mi100.instance_variable_set(:@drive_duration, Mi100::DEFAULT_DRIVE_DURATION)
    expect(mi100.drive_left 111).to eq(["Z",1234])
    expect(mi100).to have_received(:send_command_get_response).with("Z,234,123,50")
  end

  it 'should send "F,duration" on move_forward! duration in async (via sendln)' do
    Mi100.any_instance.stub(:sendln => 6)
    mi100 = Mi100.new "COM5"
    expect(mi100.move_forward! 500).to eq(6)
    expect(mi100).to have_received(:sendln).with("F,500")
  end

  it 'should send "B,duration" on move_backward! duration in async' do
    Mi100.any_instance.stub(:sendln => 6)
    mi100 = Mi100.new "COM5"
    expect(mi100.move_backward! 500).to eq(6)
    expect(mi100).to have_received(:sendln).with("B,500")
  end

  it 'should send "R,duration" on spin_right! duration in async' do
    Mi100.any_instance.stub(:sendln => 6)
    mi100 = Mi100.new "COM5"
    expect(mi100.spin_right! 500).to eq(6)
    expect(mi100).to have_received(:sendln).with("R,500")
  end

  it 'should send "L,duration" on spin_left! duration in async' do
    Mi100.any_instance.stub(:sendln => 6)
    mi100 = Mi100.new "COM5"
    expect(mi100.spin_left! 500).to eq(6)
    expect(mi100).to have_received(:sendln).with("L,500")
  end

  it 'should send "U,duration" on turn_right! duration in async' do
    Mi100.any_instance.stub(:sendln => 6)
    mi100 = Mi100.new "COM5"
    expect(mi100.turn_right! 500).to eq(6)
    expect(mi100).to have_received(:sendln).with("U,500")
  end

  it 'should send "A,duration" on turn_left! duration in async' do
    Mi100.any_instance.stub(:sendln => 6)
    mi100 = Mi100.new "COM5"
    expect(mi100.turn_left! 500).to eq(6)
    expect(mi100).to have_received(:sendln).with("A,500")
  end

  it 'should send "Z,right_speed,left_speed,duration" on drive! right_speed, left_speed, duration in async' do
    Mi100.any_instance.stub(:sendln => 6)
    mi100 = Mi100.new "COM5"
    expect(mi100.drive! 123, 234, 56).to eq(6)
    expect(mi100).to have_received(:sendln).with("Z,123,234,56")
  end

  it 'should send "Z,right_speed,left_speed,duration" on drive! right_speed, left_speed in async' do
    Mi100.any_instance.stub(:sendln => 6)
    mi100 = Mi100.new "COM5"
    mi100.instance_variable_set(:@drive_duration, Mi100::DEFAULT_DRIVE_DURATION)
    expect(mi100.drive! 123, 234).to eq(6)
    expect(mi100).to have_received(:sendln).with("Z,123,234,50")
  end

  it 'should send "Z,right_speed,left_speed,duration" on drive_right! turn_speed, speed, duration in async' do
    Mi100.any_instance.stub(:sendln => 6)
    mi100 = Mi100.new "COM5"
    expect(mi100.drive_right! 111, 123, 56).to eq(6)
    expect(mi100).to have_received(:sendln).with("Z,123,234,56")
  end

  it 'should send "Z,right_speed,left_speed,duration" on drive_right! turn_speed in async' do
    Mi100.any_instance.stub(:sendln => 6)
    mi100 = Mi100.new "COM5"
    mi100.instance_variable_set(:@speed, 123)
    mi100.instance_variable_set(:@drive_duration, Mi100::DEFAULT_DRIVE_DURATION)
    expect(mi100.drive_right! 111).to eq(6)
    expect(mi100).to have_received(:sendln).with("Z,123,234,50")
  end

  it 'should send "Z,right_speed,left_speed,duration" on drive_left! turn_speed, speed, duration in async' do
    Mi100.any_instance.stub(:sendln => 6)
    mi100 = Mi100.new "COM5"
    expect(mi100.drive_left! 111, 123, 56).to eq(6)
    expect(mi100).to have_received(:sendln).with("Z,234,123,56")
  end

  it 'should send "Z,right_speed,left_speed,duration" on drive_left! turn_speed in async' do
    Mi100.any_instance.stub(:sendln => 6)
    mi100 = Mi100.new "COM5"
    mi100.instance_variable_set(:@speed, 123)
    mi100.instance_variable_set(:@drive_duration, Mi100::DEFAULT_DRIVE_DURATION)
    expect(mi100.drive_left! 111).to eq(6)
    expect(mi100).to have_received(:sendln).with("Z,234,123,50")
  end

  it 'should send "W,pwm_value" on speed pwm_value' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_SET_SPEED,1234])
    mi100 = Mi100.new "COM5"
    expect(mi100.speed 500).to eq(["W",1234])
    expect(mi100).to have_received(:send_command_get_response).with("W,500")
  end

  it 'should reset default speed' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_SET_SPEED,1234])
    mi100 = Mi100.new "COM5"
    expect(mi100.speed Mi100::DEFAULT_SPEED).to eq(["W",1234])
    expect(mi100).to have_received(:send_command_get_response).with("W,1023")
  end

  it 'should set drive_duration to 56mS' do
    mi100 = Mi100.new "COM5"
    expect(mi100.drive_duration 56).to eq(mi100.instance_variable_get(:@drive_duration))
  end

  it 'should send "M" and get free ram memory area on :free_ram' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_FREE_RAM,1234])
    mi100 = Mi100.new "COM5"
    expect(mi100.free_ram).to eq(["M",1234])
    expect(mi100).to have_received(:send_command_get_response).with("M")
  end

  it 'should send "D,100,50,50,duration" on blink 100,50,50,duration' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_BLINK_LED,1234])
    mi100 = Mi100.new "COM5"
    expect(mi100.blink 100,50,50,100).to eq(["D",1234])
    expect(mi100).to have_received(:send_command_get_response).with("D,100,50,50,100")
  end

  it 'should send "V,100,0,100" on turn_led 100,0,100' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_TURN_LED_RGB,1234])
    mi100 = Mi100.new "COM5"
    expect(mi100.turn_led 100,0,100).to eq(["V",1234])
    expect(mi100).to have_received(:send_command_get_response).with("V,100,0,100")
  end

  it 'should send "S" on stop' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_STOP,1234])
    mi100 = Mi100.new "COM5"
    expect(mi100.stop).to eq(["S",1234])
    expect(mi100).to have_received(:send_command_get_response).with("S")
  end

  it 'should send "T,random frequency, 300" on tone' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_TONE,1234])
    mi100 = Mi100.new "COM5"
    expect(mi100.tone).to eq(["T",1234])
    expect(mi100).to have_received(:send_command_get_response).with(/T,\d{2,4},300/)
  end

  it 'should limit minimum tone frequency to 28 on tome' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_TONE,1234])
    mi100 = Mi100.new "COM5"
    mi100.tone 20, 500
    expect(mi100).to have_received(:send_command_get_response).with("T,28,500")
  end

  it 'should send "T,440,1000" on sound "la", 1000' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_TONE,1234])
    mi100 = Mi100.new "COM5"
    mi100.sound "la",1000
    expect(mi100).to have_received(:send_command_get_response).with("T,440,1000")
  end

  it 'sound should not call tone with false frequency' do
    mi100 = Mi100.new "COM5"
    mi100.stub(:tone)
    mi100.sound false, 300
    expect(mi100).not_to have_received(:tone)
  end

  it 'should send three good tones on good' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_TONE,1234])
    mi100 = Mi100.new "COM5"
    mi100.good
    expect(mi100).to have_received(:send_command_get_response).exactly(3).times
  end

  it 'should send one bad tone on bad' do
    Mi100.any_instance.stub(:send_command_get_response => [Mi100::CMD_TONE,1234])
    mi100 = Mi100.new "COM5"
    mi100.bad
    expect(mi100).to have_received(:send_command_get_response).once
  end

  it 'should talk morse code' do
    mi100 = Mi100.new "COM5"
    mi100.stub(:tone)
    mi100.talk "sos"
    expect(mi100).to have_received(:tone).exactly(6).times.with(4000,50)
    expect(mi100).to have_received(:tone).exactly(3).times.with(4000,150)
  end

  it 'should access to morse_frequency' do
    mi100 = Mi100.new "COM5"
    expect(mi100.morse_frequency).to eq(4000)
    expect(mi100.morse_frequency = 440).to eq(440)
    expect(mi100.morse_frequency).to eq(440)
  end

  it 'should access to morse_unit' do
    mi100 = Mi100.new "COM5"
    expect(mi100.morse_unit).to eq(50)
    expect(mi100.morse_unit = 100).to eq(100)
    expect(mi100.morse_unit).to eq(100)
  end

  it 'should talk with new default frequency and unit' do
    mi100 = Mi100.new "COM5"
    mi100.stub(:tone)
    mi100.talk "sos"
    expect(mi100).to have_received(:tone).exactly(6).times.with(440,100)
    expect(mi100).to have_received(:tone).exactly(3).times.with(440,300)
  end

  it 'should reset default frequency and unit' do
    Mi100::Morsecoder.reset
    expect(Mi100::Morsecoder.default_frequency).to eq(4000)
    expect(Mi100::Morsecoder.default_unit).to eq(50)
    mi100 = Mi100.new "COM5"
    expect(mi100.morse_frequency).to eq(4000)
    expect(mi100.morse_unit).to eq(50)
  end

  it 'should provide Morsecode.to_morse_from class method converting the string to the morse code array' do
    morsecode = Mi100::Morsecoder.to_morse_from "sos"
    expect(morsecode.size).to eq(21)
    expect(morsecode[0]).to eq ({:frequency=>4000, :duration=>50})
  end

end
