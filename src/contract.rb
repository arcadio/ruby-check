require 'property'


class Contract < Property

  attr_reader :method, :precondition, :postcondition

  def initialize(method, types, precondition = nil, postcondition = nil, &block)
    raise ArgumentError, 'wrong method' if method.nil?
    raise ArgumentError, 'wrong type list' unless types.length == method.arity
    @method = method
    @precondition = precondition
    @postcondition = postcondition
    instance_eval(&block) if block != nil
    a = method.arity
    raise ArgumentError, 'wrong precondition arity' if @precondition.arity != a
    raise ArgumentError, 'wrong postcondition arity' if @postcondition.arity != a + 1
    super("#{method.owner.name}.#{method.name}".to_sym, types,
          &build_predicate(types))
  end

  private

  def requires(&expr)
    @precondition = expr
  end

  def ensures(&expr)
    @postcondition = expr
  end

  def build_predicate(types)
    id = 'a'
    params = Array.new(types.length) { |i| p = id; id = id.next; p }
    pstr = params.inject('') { |i,e| i += e + ',' }[0..-2]
    predicate = eval "lambda { |#{pstr}| }"
  end
end
