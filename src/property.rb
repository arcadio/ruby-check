def desc(doc); end

def property(sig, &block)
  Property.new(sig, &block)
end


class Property
  attr_reader :key, :types, :pred

  def initialize(sig, &block)
    @key, @types = dump_s(sig)
    if block.arity > 0 or @types.size == 0
      predicate(&block)
    else
      instance_eval(&block)
    end
  end

  def predicate(&expr)
    ts = @types.size
    pa = expr.arity != -1 ? expr.arity : 0
    if ts != pa
      raise ArgumentError.new("The number of types (#{ts}) doesn't" +
                              " match the arity (#{pa}) of the predicate")
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
      raise ArgumentError.new("Incorrect property signature")
    end
  end

  def dump_h(hash)
    if hash.size != 1
      raise ArgumentError.new("Incorrect property signature")
    end
    ary = hash.to_a
    types = ary.first.last
    [ary.first.first, types.is_a?(Array) ? types : [types]]
  end
end
