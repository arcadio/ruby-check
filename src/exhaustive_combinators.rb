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
      yield(Array.new(@ary.length) do |i|
              @ary[i].exhaustive(@n).entries.first
            end)
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

  # class ProductCombinator
  #   def initialize(*ary)
  #     @ary = ary
  #   end

  #   def exhaustive(n)
  #     Product.new(n, @ary)
  #   end


  #   class Product
  #     include Enumerable

  #     def initialize(n, ary)
  #       @n = n
  #       @ary = ary
  #     end

  #     def each(&block)
  #       yield(Array.new(@ary.length) do |i|
  #               @ary[i].exhaustive(@n).entries.first
  #             end)
  #     end
  #   end
  # end





  # class UnionCombinator
  #   def initialize(*ary)
  #     @ary = ary
  #   end

  #   def exhaustive(n)
  #     Union.new(n, @ary)
  #   end


  #   class Union
  #     include Enumerable

  #     def initialize(n, ary)
  #       @n = n
  #       @ary = ary
  #     end

  #     def each(&block)
  #       @ary.each do |e|
  #         e.exhaustive(@n).each { |e| yield(e) }
  #       end
  #     end
  #   end
  # end
end
