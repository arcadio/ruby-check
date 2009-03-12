class BatchUI
  def initialize(runner)
  end

  def step_case
    print '.'
  end

  def next_property(property)
    puts property.key.to_s
  end

  def success
    puts 'Success'
  end

  def failure(cause = nil)
    puts 'Failure'
    puts cause if cause
  end
end
