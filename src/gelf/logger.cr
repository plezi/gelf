require "logger"
require "habitat"
require "zlib"
require "json"

require "./severity"

module GELF
  # The `GELF::Logger` class provides a simple but sophisticated logging utility that you can use to output messages.
  #
  # The messages have associated levels, such as `INFO` or `ERROR` that indicate their importance.
  # You can then give the `GELF::Logger` a level, and only messages at that level of higher will be printed.
  #
  # Messages will be sent with a sender (default: `GELF::SenderUDP`)
  class Logger < ::Logger
    Habitat.create do
      setting host : String
      setting port : Int32
      setting progname : String
      setting chunk_size : Int32 = 1420
      setting severity_mapper : Hash(::Logger::Severity, Int32) = GELF::LOGGER_MAPPING
      setting base_severity : ::Logger::Severity = ::Logger::INFO
    end

    def initialize(@sender : Sender = SenderUDP.new(settings.host, settings.port))
      super(STDOUT)
    end

    {% for name in ::Logger::Severity.constants %}
      def {{name.id.downcase}}(message, progname = settings.progname, options = Hash(String, String).new)
        log(::Logger::Severity::{{name.id}}, message, progname.ljust(10), options)
      end
    {% end %}

    def log(severity, message, progname = settings.progname, options = Hash(String, String).new)
      return if settings.severity_mapper[severity] > settings.severity_mapper[settings.base_severity]

      write(severity, message, progname, options)
    end

    private def write(severity, message, progname, options : Hash(String, String) = Hash(String, String).new)
      data = {
        "short_message" => message,
        "version" => "1.1",
        "host" => settings.host,
        "level" => settings.severity_mapper[severity],
        "_source" => "pepper_potts",
        "_facility" => progname
      }

      serialized_data = serialize_message(populate_options(data, options))

      if serialized_data.size > chunk_size
        msg_id = Random::Secure.hex(4)
        num_slices = (serialized_data.size / chunk_size).ceil.to_i

        num_slices.times do |index|
          io = IO::Memory.new

          # Magic bytes
          io.write_byte(0x1e_u8)
          io.write_byte(0x0F_u8)

          # Message id
          io.write(msg_id.to_slice)

          # Chunk info
          io.write_byte(index.to_u8)
          io.write_byte(num_slices.to_u8)

          # Bytes
          bytes_to_send = [serialized_data.size, chunk_size].min
          io.write(serialized_data[0, bytes_to_send])
          serialized_data += bytes_to_send

          @sender.write(io.to_slice)
        end
      else
        @sender.write(serialized_data)
      end
    end

    private def chunk_size
      settings.chunk_size
    end

    private def populate_options(data, options)
      options.each do |k, v|
        data["_#{k}"] = v
      end

      data
    end

    private def serialize_message(message)
      io = IO::Memory.new
      deflater = Zlib::Writer.new(io)
      json = message.to_json
      deflater.write(json.to_slice)
      deflater.close
      io.to_slice
      json.to_slice
    end
  end
end
