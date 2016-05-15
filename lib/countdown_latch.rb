require "countdown_latch/version"
require "thread"

module CountdownLatch

  class CountdownLatch
    attr_reader :count

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
        unless @count == 0
          @count -= 1
        else
          # NOTE: calling `signal` is wrong because this only wakes _one_
          #       of the waiting threads.
          # @condition.signal
          @condition.broadcast
        end
      }
    end

    def await
      @mutex.synchronize {
        # _wait_ takes in a mutex. this is when we can introduce the mutex.
        @condition.wait(@mutex)
      }
    end

  end

end
