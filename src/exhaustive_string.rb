class String
  def self.exhaustive(n)
    StringIterator.new(n)
  end

  class StringIterator
    include Enumerable

    def initialize(n)
      @n = n
    end

    def each(&block)
      s = "a" * @n
      for i in 0..3
        yield(s)
        s = s.next
      end
    end
  end
end
