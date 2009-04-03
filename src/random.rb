module Random
  def frequency(hash)
    FrequencyCombinator.new(hash)
  end


  class FrequencyCombinator
    def initialize(hash)
      @values = []
      hash.each_pair { |k,v| v.times { @values << k } }
    end

    def arbitrary
      e = @values[rand(@values.size)]
      e.respond_to?(:arbitrary) ? e.arbitrary : e
    end
  end


  def one_of(*ary)
    expanded = []
    ary.each { |e| e.is_a?(Enumerable) ? expanded += e.to_a : expanded << e }
    hash = {}
    expanded.each { |e| hash[e] = 1 }
    frequency(hash)
  end
end


class String
  extend Random

  @@alphabet = one_of(65..90, 97..122)
  @@control = one_of(0..32, 177)
  @@number = one_of(48..57)
  @@special = one_of(33..47, 58..64, 91..96, 123..126)

  class StringGenerator
    def initialize(length, char)
      @length = length
      @char = char
    end

    def arbitrary
      s = ''
      @length.arbitrary.times { s += @char.arbitrary.chr }
      s
    end
  end

  @@gen = StringGenerator.new(one_of(0..5),
                              frequency({ @@alphabet => 200, @@control => 1,
                                          @@number => 50, @@special => 1 }))

  def self.arbitrary
    @@gen.arbitrary
  end

  def self.of(a, c, n, s)
    StringGenerator.new(length = one_of(0..5),
                        frequency({ @@alphabet => a, @@control => c, @@number => n,
                                    @@special => s }))
  end
end
