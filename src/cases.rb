require 'strategy'


class Cases < Strategy
  private

  def set(property)
    @i = 0
  end

  def gen
    c = @property.cases[@i]
    @i += 1
    c
  end

  def exh
    @property.cases.nil? or @property.cases.size == @i
  end

  def pro
    @property.cases ? @i.to_f / @property.cases.size : 0
  end
end
