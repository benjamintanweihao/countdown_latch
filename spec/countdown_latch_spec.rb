require 'spec_helper'
require 'sample/chucky'

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

      x = []
      Thread.new do
        x << "bar"
        latch.count_down
      end

      # sleep(0.01)

      Thread.new do
        x << "baz"
        latch.count_down
      end

      # sleep(0.01)

      Thread.new do
        x << "qux"
        latch.count_down
      end

      latch.await

      expect(latch.count).to eq(0)
      expect(x.length).to eq(3)
    end

    xit "sample run", :speed => 'slow' do
      chucky = Chucky.new
      facts = chucky.get_facts(5)

      expect(facts.size).to eq(5)
    end

  end

end
