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
      r = (0..127).to_a.map { |e| e.chr }
      unless @n == 0
        eval genc, binding
      else
        yield('')
      end
    end

    def genc
      v = 'a'
      command = ''
      vars = []
      for i in 0..@n-1
        command += "for #{v} in r\n"
        vars << v
        v = v.next
      end
      y = vars.inject('') { |s,e| s += e + '+' }[0..-2]
      command += "yield(#{y})\n"
      for i in 0..@n-1
        command += "end\n"
      end
      command
    end
  end
end
