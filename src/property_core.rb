require 'property_class'
require 'property_cases'


class Property
  attr_reader :key, :types, :pred

  def initialize(signature, &block)
    raise ArgumentError, 'a block must be provided' if block.nil?
    @key, @types = dump_signature(signature)
    if block.arity > 0 or types.size == 0
      predicate(&block)
    else
      instance_eval(&block)
      raise ArgumentError, 'property predicate should be defined' if pred.nil?
    end
    @@pp[key] = self
  end

  def predicate(&expr)
    self.pred = expr
  end

  private

  def pred=(expr)
    ts = types.size
    arity = expr.arity != -1 ? expr.arity : 0
    if ts != arity
      raise ArgumentError, "wrong number of types (#{ts} for #{arity})"
    end
    @pred = expr
  end

  def dump_signature(signature)
    if signature.is_a?(Hash)
      dump_hash(signature)
    elsif signature.is_a?(Symbol)
      [signature, []]
    else
      raise ArgumentError, 'incorrect property signature'
    end
  end

  def dump_hash(hash)
    if hash.size != 1 or !hash.keys.first.is_a?(Symbol)
      raise ArgumentError, 'incorrect property signature'
    end
    ary = hash.to_a
    types = ary.first.last
    [ary.first.first, types.is_a?(Array) ? types : [types]]
  end
end
