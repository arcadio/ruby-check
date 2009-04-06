require 'strategy'


class ExhaustiveStrategy < Strategy
  include Exhaustive

  private

  def set(property)
    if can
      @depth = 0
      @tuple = product(*@property.types)
      @resume = nil
      @ret = nil
    end
  end

  def gen
    unless @resume
      @resume, r = callcc do |c1|
        @ret = c1
        @tuple.exhaustive(@depth).each { |e| callcc { |c| @ret.call(c, e) } }
      end
      @depth += 1
    else
      @resume, r = callcc do |c1|
        @ret = c1
        @resume.call
      end
    end
    r
  end

  # tener en cuenta caso vacio
  # def gen
  #   if @resume
  #     resume, result = @resume.call
  #   else
  #     # utilizar callcc nuevo cada vez
  #     resume, result = callcc do |c1|
  #       @tuple.exhaustive(@depth).each do |e|
  #         callcc { |c2| c1.call(c2, e) }
  #       end
  #     end
  #   end
  #   if !resume.is_a?(Continuation)
  #     @depth += 1
  #     @resume = nil
  #     gen
  #   else
  #     @resume = resume
  #     result
  #   end
  # end

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
