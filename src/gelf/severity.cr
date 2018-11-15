module GELF
  LOGGER_MAPPING = {
    ::Logger::DEBUG   => 7, # Debug
                            # Info
    ::Logger::INFO    => 5, # Notice
    ::Logger::UNKNOWN => 4, # Warning
    ::Logger::WARN    => 4, # Warning
                            # Error
    ::Logger::ERROR   => 2, # Critical
                            # Alert
    ::Logger::FATAL   => 0  # Emergency
  }
end
