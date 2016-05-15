require "countdown_latch/version"
require "thread"

module CountdownLatch

  class CountdownLatch

    def initialize(count)
      if count.is_a?(Fixnum) && count >= 0
        @count = count
        @mutex = Mutex.new
        @condition = ConditionVariable.new
      else
        raise ArgumentError
      end
    end

    def count_down
      @mutex.synchronize {
        if @count.zero?
          @condition.signal
        else
          @count -= 1
        end
      }
    end

    def count
      @mutex.synchronize {
        @count
      }
    end

    def await
      @mutex.synchronize {
        @condition.wait(@mutex) if @count > 0
      }
    end

  end

end
