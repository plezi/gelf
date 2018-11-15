require "../spec_helper"
require "../fixtures/test_sender"

def instance_with(severity)
  GELF::Logger.configure do |settings|
    settings.host = ""
    settings.port = 0
    settings.progname = "spec"
    settings.base_severity = severity
  end

  sender = TestSender.new
  instance = GELF::Logger.new(sender)

  { instance: instance, sender: sender }
end

describe GELF::Logger do
  describe "#log" do
    context "with bigger base severity" do
      it "should return a message" do
        data = instance_with(::Logger::DEBUG)
        data[:instance].log(::Logger::DEBUG, "message")
        data[:sender].count.should eq(1)
      end
    end

    context "with lower base severity" do
      it "should not return a message" do
        data = instance_with(::Logger::FATAL)
        data[:instance].log(::Logger::DEBUG, "message")
        data[:sender].count.should eq(0)
      end
    end
  end

  describe "#debug" do
    context "with bigger base severity" do
      it "should return a message" do
        data = instance_with(::Logger::DEBUG)
        data[:instance].debug("message")
        data[:sender].count.should eq(1)
      end
    end

    context "with lower base severity" do
      it "should not return a message" do
        data = instance_with(::Logger::FATAL)
        data[:instance].debug("message")
        data[:sender].count.should eq(0)
      end
    end
  end

  describe "#info" do
    context "with bigger base severity" do
      it "should return a message" do
        data = instance_with(::Logger::DEBUG)
        data[:instance].info("message")
        data[:sender].count.should eq(1)
      end
    end

    context "with lower base severity" do
      it "should not return a message" do
        data = instance_with(::Logger::FATAL)
        data[:instance].info("message")
        data[:sender].count.should eq(0)
      end
    end
  end

  describe "#unknown" do
    context "with bigger base severity" do
      it "should return a message" do
        data = instance_with(::Logger::DEBUG)
        data[:instance].unknown("message")
        data[:sender].count.should eq(1)
      end
    end

    context "with lower base severity" do
      it "should not return a message" do
        data = instance_with(::Logger::FATAL)
        data[:instance].unknown("message")
        data[:sender].count.should eq(0)
      end
    end
  end

  describe "#warn" do
    context "with bigger base severity" do
      it "should return a message" do
        data = instance_with(::Logger::DEBUG)
        data[:instance].warn("message")
        data[:sender].count.should eq(1)
      end
    end

    context "with lower base severity" do
      it "should not return a message" do
        data = instance_with(::Logger::FATAL)
        data[:instance].warn("message")
        data[:sender].count.should eq(0)
      end
    end
  end

  describe "#error" do
    context "with bigger base severity" do
      it "should return a message" do
        data = instance_with(::Logger::DEBUG)
        data[:instance].error("message")
        data[:sender].count.should eq(1)
      end
    end

    context "with lower base severity" do
      it "should not return a message" do
        data = instance_with(::Logger::FATAL)
        data[:instance].error("message")
        data[:sender].count.should eq(0)
      end
    end
  end

  describe "#fatal" do
    context "with bigger base severity" do
      it "should return a message" do
        data = instance_with(::Logger::DEBUG)
        data[:instance].fatal("message")
        data[:sender].count.should eq(1)
      end
    end

    context "with lower base severity" do
      it "should return a message" do
        data = instance_with(::Logger::FATAL)
        data[:instance].fatal("message")
        data[:sender].count.should eq(1)
      end
    end
  end
end
