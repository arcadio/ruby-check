require 'property_class'

def desc(doc); end

def property(sig, &block)
  Property.new(sig, &block)
end


class Property
  attr_reader :key, :types, :pred, :arity

  def initialize(sig, &block)
    @key, @types = dump_s(sig)
    if block.arity > 0 or @types.size == 0
      predicate(&block)
    else
      instance_eval(&block)
      raise "Property predicate should be defined" if pred.nil?
    end
    @@pp[key] = self
  end

  def predicate(&expr)
    self.pred = expr
  end

  def pred=(expr)
    ts = @types.size
    @arity = expr.arity != -1 ? expr.arity : 0
    if ts != @arity
      raise ArgumentError, "wrong number of types (#{ts} for #{@arity})"
    end
    @pred = expr
  end

  private

  def dump_s(sig)
    if sig.is_a?(Hash)
      dump_h(sig)
    elsif sig.is_a?(Symbol)
      [sig, []]
    else
      raise ArgumentError, "incorrect property signature"
    end
  end

  def dump_h(hash)
    if hash.size != 1 or !hash.keys.first.is_a?(Symbol)
      raise ArgumentError, "incorrect property signature"
    end
    ary = hash.to_a
    types = ary.first.last
    [ary.first.first, types.is_a?(Array) ? types : [types]]
  end
end
