require 'generator'
require 'strategy'


class ExhaustiveStrategy < Strategy
  include Exhaustive

  def initialize(goal = 2)
    @goal = goal
  end

  private

  def set(property)
    if can
      @tuple = product(*@property.types)
      @next_depth = 0
      set_gen
    end
  end

  def set_gen
    @generator = Generator.new(@tuple.exhaustive(@next_depth))
    @next_depth += 1
  end

  def gen
    if @generator.next?
      @generator.next
    else
      set_gen
      gen
    end
    # subir contador a mano para depth
  end

  def can
    @property.types.all? { |t| t.respond_to?(:exhaustive) }
  end

  def exh
    false
  end

  def pro
    (@next_depth - 1).to_f / @goal
  end
end
