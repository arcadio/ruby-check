require 'forwardable'


class BatchUI
  extend Forwardable

  def_delegators :@output, :print, :puts

  def initialize(runner, output = $stdout)
    @output = output
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
