require 'forwardable'
require 'set'


class CoverTable
  extend Forwardable

  def_delegator :@actual, :empty?, :covered?

  def initialize
    @reference = Set[]
    @actual = Set[]
  end

  def add(expr, *values)
    values.each do |v|
      a = Set[[expr, v]]
      @reference += a
      @actual += a
    end
  end

  def eval(expr, op, left, right)
    r = left.call.send(op, right.call)
    @actual -= Set[[expr, r]]
    r
  end

  def reset!
    @actual = Set.new(@reference)
  end
end
