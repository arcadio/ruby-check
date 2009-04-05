require 'initializer'


module Exhaustive
  def product(*ary)
    ProductCombinator.new(ary)
  end

  def union(*ary)
    UnionCombinator.new(ary)
  end


  class Combinator
    initialize_with :ary, :finalc

    def exhaustive(n)
      @finalc.new(n, @ary)
    end
  end


  class ProductCombinator < Combinator
    def initialize(ary)
      super(ary, Product)
    end
  end


  class UnionCombinator < Combinator
    def initialize(ary)
      super(ary, Union)
    end
  end


  class Product
    include Enumerable

    initialize_with :n, :ary

    def each(&block)
      eval genc, binding
    end

    def genc
      v = 'a'
      command = ''
      vars = []
      for i in 0..@ary.size-1
        command += "@ary[#{i}].exhaustive(@n).each do |#{v}|\n"
        vars << v
        v = v.next
      end
      y = vars.inject('') { |s,e| s += e + ',' }[0..-2]
      command += "yield([#{y}])\n"
      for i in 0..@ary.size-1
        command += "end\n"
      end
      command
    end
  end


  class Union
    include Enumerable

    initialize_with :n, :ary

    def each(&block)
      @ary.each do |e|
        e.exhaustive(@n).each { |e| yield(e) }
      end
    end
  end
end
