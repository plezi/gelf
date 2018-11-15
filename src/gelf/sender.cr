require "socket"

module GELF
  abstract class Sender
    abstract def write(slice) : Void
  end

  # A `GELF::SenderUDP` send message to the knew host through UPD protocole.
  class SenderUDP < Sender
    def initialize(host, port)
      @client = UDPSocket.new
      @client.connect(host, port)
    end

    def finalize
      close
    end

    def write(slice)
      @client.write(slice)
    end

    def close
      @client.close
    end
  end
end
