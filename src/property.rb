def desc(doc); end

def property(key, types = [], &block)
  Property.new(key, types, &block)
end


class Property
  def initialize(key, types = [], &block)
    @types = types
    if block.arity > 0
      predicate(&block)
    else
      instance_eval(&block)
    end
  end

  def predicate(&expr)
    ts = @types.size
    pa = expr.arity
    if ts != pa
      raise ArgumentError.new("The number of types (#{ts}) doesn't match the arity (#{pa}) of the predicate")
    end
    @pred = expr
  end
end
