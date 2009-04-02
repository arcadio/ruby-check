require 'property'


class Contract < Property

  attr_reader :method, :precondition, :postcondition

  def initialize(method, types, precondition = nil, postcondition = nil, &block)
    raise ArgumentError, 'wrong method' unless method.is_a?(Method)
    raise ArgumentError, 'wrong type list' unless types.length == method.arity
    @method = method
    @precondition = precondition
    @postcondition = postcondition
    # si block dif nil comprobar arity y evaluar
    # instance_eval(&block)
    super("#{method.owner}.#{method.name}".to_sym, types, &build_predicate(types))
    # precondition y postcondition not nil
    # precondition y postcondition tienen que tener method arity y +1
    a = method.arity
    raise ArgumentError, 'wrong precondition arity' if precondition.arity != a
    raise ArgumentError, 'wrong postcondition arity' if postcondition.arity != a + 1
  end

  private

  def build_predicate(types)
    a = 'a'
    params = Array.new(types.length) { |i| e = a; a = a.next; e }
    pstr = params.inject('') { |i,e| i += e + ',' }[0..-2]
    predicate = eval "lambda { |#{pstr}| }"
  end
end
