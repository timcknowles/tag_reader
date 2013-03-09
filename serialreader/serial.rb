require 'rubygems'
require "serialport"

#if ARGV.size < 4
#  STDERR.print <<-EOF
#Usage: ruby #{$0} num_port bps nbits stopb
#  EOF
#  exit(1)
#end

#sp = SerialPort.new(ARGV[0].to_i, ARGV[1].to_i, ARGV[2].to_i, ARGV[3].to_i, SerialPort::NONE)

foobar = [] 

open("/dev/tty.usbmodemfa121", "r+") do |tty|
  tty.sync = true
  Thread.new {
    while true do
      p "hey"
      tty.printf("%c", sp.getc)
    end
  }
  while (l = tty.gets) do
    foobar << l.strip
  end
end

foobar = foobar.join("")
p foobar
