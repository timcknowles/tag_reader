
require 'rubygems'
require "serialport"

class SerialNumberMonitor
  def initialize
    setup_serial_port
    monitor_port
  end

  private

    def setup_serial_port
      port_str = "/dev/tty.usbmodemfd121"
      baud_rate = 9600
      data_bits = 8
      stop_bits = 1
      parity = SerialPort::NONE
       
      @sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)
    end

    def monitor_port
      @current_serial_number = []
      open("/dev/tty.usbmodemfd121", "r+") do |tty|
        tty.sync = true
        while true do
          if byte = tty.gets
            process_byte(byte.strip.to_i)
          end
        end
      end

      sp.close
    end

    def process_byte(byte)
      @current_serial_number = [] if byte == 2
      @current_serial_number << byte
      code_complete if byte == 3
    end

    def code_complete
      code = @current_serial_number.join("")
      Thread.new do
        url = "http://localhost:3000/visits.json?"
        system "curl #{url} -d 'visit[rfid]=#{code}'"
      end
      @current_serial_number = []
    end
end

SerialNumberMonitor.new