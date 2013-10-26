# Mi100

Controlling your Bluetooth<sup>&reg;</sup> wireless technology embedded robot MI100.


## Installation

Add this line to your application's Gemfile:

    gem 'mi100'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mi100

## Usage

Pairing must be performed between a *Bluetooth* wireless technology enabled device and MI100 in advance.  
The below example shows that pairing is done between a Windows device and MI100, and the virtual serial port is COM12.  

	require 'serialport' #hybridgroup-serialport
	require 'mi100'
	
	mi100 = Mi100.new 'COM12'
	
	3.times do
	  res = mi100.ping
	
	  # Get battery level
	  res = mi100.power
	  puts res
	
	  # Move forward 300mS
	  mi100.move "forward", 300
	
	  # Move backward 300mS
	  mi100.move "backward", 300
	
	  # Spin right 500mS
	  mi100.spin "right", 500
	
	  # Spin left 500mS
	  mi100.spin "left", 500
	
	  # Blink LED 100% red, 50% green, 20% blue 1000mS
	  mi100.blink 100, 50, 20, 1000
	  
	  # LED random color blink 
	  mi100.blink
	  
	  # Tone 440Hz 200mS
	  mi100.tone 440, 200
	  
	  # Do Re Mi
	  mi100.sound "DO"
	  mi100.sound "RE"
	  mi100.sound "MI"
	
	  sleep 1
	end
	
	mi100.close

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
