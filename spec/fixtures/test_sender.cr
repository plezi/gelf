class TestSender < GELF::Sender
  @count = 0
  @last_message : Bytes?

  def write(message)
    @last_message = message
    @count += 1
  end

  def message
    @last_message
  end

  def count
    @count
  end
end
