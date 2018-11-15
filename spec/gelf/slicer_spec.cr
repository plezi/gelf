require "../spec_helper"

describe GELF::Slicer do
  describe "with empty data" do
    it "is an array" do
      instance = GELF::Slicer.new(10)

      instance.call(Bytes.new(0)).should eq([] of Bytes)
    end
  end

  describe "with data" do
    it "slice one array" do
      instance = GELF::Slicer.new(2)

      instance.call("as".to_slice).size.should eq(1)
    end

    it "slice two array" do
      instance = GELF::Slicer.new(2)

      instance.call("test".to_slice).size.should eq(2)
    end
  end
end
