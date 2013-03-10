require 'rubygems'
require "serialport"

#if ARGV.size < 4
#  STDERR.print <<-EOF
#Usage: ruby #{$0} num_port bps nbits stopb
#  EOF
#  exit(1)
#end

#sp = SerialPort.new(ARGV[0].to_i, ARGV[1].to_i, ARGV[2].to_i, ARGV[3].to_i, SerialPort::NONE)

rails generate resource person name:string rfid_code:string 

# serial_number_monitor.rb
class SerialNumberMonitor

  def initialize
    current_serial_number = []
    max_length = 10
    while true do
      open("/dev/tty.usbmodemfa121", "r+") do |tty|
        tty.sync = true
        #Thread.new {
        #  while true do
        #    p "hey"
        #    tty.printf("%c", sp.getc)
        #  end
        #}
        while (l = tty.gets) do
          current_serial_number << l.strip

          if current_serial_number.length == max_length
            Thread.new { check_serial_number(current_serial_number) }
            current_serial_number = []
          end
        end
      end
    end
  end

  def check_serial_number(code)

    if person = Person.find_by_rdif_code(code)
      person.visited!
      Door.open
      Door.play_nice_entry_tune
    else
      Door.growl
    end
  end
end

# person.rb
require 'active_record'
class Person < ActiveRecord::Base

  has_many :visits

  def visited!
    vists.create!
  end
end

# Gemfile
source 'http://rubygems.org'
gem 'active_record'