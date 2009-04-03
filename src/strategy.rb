class Strategy
  def initialize
    @property = nil
  end

  def set_property(property)
    @property = property
    set(property)
  end

  def generate
    @property and !exhausted ? gen : error
  end

  def exhausted
    @property ? exh : error
  end

  def progress
    @property ? pro : error
  end

  private

  def error
    raise 'Wrong state'
  end
end
