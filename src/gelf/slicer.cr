module GELF
  # A `GELF::Slicer` is an object, who cut bytes into multiples pieces.
  #
  # It adds information to each pieces to help Grayman recompose messages.
  class Slicer
    def initialize(@size : Int32)
    end

    def call(data : Bytes) : Array(Bytes)
      msg_id = Random::Secure.hex(4)
      num_slices = (data.size / @size.to_f).ceil.to_i

      Array(Bytes).new(num_slices) do |index|
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
        bytes_to_send = [data.size, @size].min
        io.write(data[0, bytes_to_send])
        data += bytes_to_send

        io.to_slice
      end
    end
  end
end
