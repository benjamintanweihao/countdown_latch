require 'open-uri'
require 'json'

module CountdownLatch

  class Chucky
    URL = 'http://api.icndb.com/jokes/random'

    def get_fact
      open(URL) do |f|
        f.each_line { |line| puts JSON.parse(line)['value']['joke'] }
      end
    end

    def get_facts(num)
      latch = CountdownLatch.new(num)

      facts = []
      (1..num).each do |x|
        Thread.new do
          facts << get_fact
        end
      end

      latch.await

      facts
    end

  end
end
