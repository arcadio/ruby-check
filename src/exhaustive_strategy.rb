require 'strategy'


class ExhaustiveStrategy < Strategy
  include Exhaustive

  private

  def set(property)
    if can
      @depth = 0
      @tuple = product(*@property.types)
      @resume = nil
    end
  end

  # tener en cuenta caso vacio tmb
  def gen
    if @resume
      resume, result = @resume.call
    else
      # utilizar callcc nuevo cada vez
      resume, result = callcc do |c1|
        @tuple.exhaustive(@depth).each do |e|
          callcc { |c2| c1.call(c2, e) }
        end
      end
    end
    if !resume.is_a?(Continuation)
      @depth += 1
      @resume = nil
      gen
    else
      @resume = resume
      result
    end
  end

  def can
    @property.types.all? { |t| t.respond_to?(:exhaustive) }
  end

  def exh
    false
  end

  def pro
    0
  end
end
