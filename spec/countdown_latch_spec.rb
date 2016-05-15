require 'spec_helper'

module CountdownLatch

  describe CountdownLatch do
    it "requires a non-negative integer as an argument" do
      latch = CountdownLatch.new(3)
      expect(latch.count).to eq(3)
    end

    it "zero is a valid argument" do
      latch = CountdownLatch.new(0)
      expect(latch.count).to eq(0)
    end

    it "throws ArgumentError for negative numbers" do
      expect { CountdownLatch.new(-1) }.to raise_error(ArgumentError)
    end

    it "throws ArgumentError for non-integers" do
      expect { CountdownLatch.new(1.0) }.to raise_error(ArgumentError)
    end

    it "#count decreases when #count_down is called" do
      latch = CountdownLatch.new(3)
      latch.count_down
      expect(latch.count).to eq(2)
    end

    it "#count never reaches below zero" do
      latch = CountdownLatch.new(0)
      latch.count_down
      expect(latch.count).to eq(0)
    end

    it "#await will wait for a thread to finish its work" do
      latch = CountdownLatch.new(1)

      Thread.new do
        latch.count_down
      end

      latch.await
      expect(latch.count).to eq(0)
    end

    it "#await will wait for threads to finish their work" do
      latch = CountdownLatch.new(3)

      x = "foo"
      Thread.new do
        x = "bar"
        latch.count_down
      end

      Thread.new do
        x = "baz"
        latch.count_down
      end

      Thread.new do
        x = "qux"
        latch.count_down
      end

      latch.await

      expect(latch.count).to eq(0)
      expect(x).to eq("qux")
    end

  end

end
