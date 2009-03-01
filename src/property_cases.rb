require 'property_core'


class Property
  attr_reader :cases

  def always_check(*cases)
    cases.each(&:to_a)
    arity = types.size
    if cases.map { |e| e.size == arity }.inject(:&)
      raise ArgumentError, "wrong number of cases for #{arity}"
    end
    @cases = cases
  end
end
