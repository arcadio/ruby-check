require 'forwardable'


class BatchUI
  extend Forwardable

  def_delegators :@output, :print, :puts

  def initialize(output = $stdout)
    @output = output
  end

  def update(key, value = nil)
    params = value ? [value] : []
    self.send(key, *params)
  end

  private

  def properties(n)
    puts "Checking #{n} properties"
  end

  def next(property)
    puts property.key.to_s
  end

  def step
    print '.'
  end

  def success
    puts 'Success'
  end

  def failure(cause = nil)
    puts 'Failure'
    puts cause if cause
  end
end
