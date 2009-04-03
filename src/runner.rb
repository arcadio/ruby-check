require 'observer'
require 'pipeline'
require 'ui'


class Runner
  include Filter, Observable

  def process(i)
    add_observer(UI.new(self)) if count_observers == 0
    notify_properties(i)
    check(i)
  end

  private

  def notify_properties(properties)
    changed
    notify_observers(:properties, properties.size)
  end

  def notify_next(property)
    changed
    notify_observers(:next, property)
  end

  def notify_step
    changed
    notify_observers(:step)
  end

  def notify_success
    changed
    notify_observers(:success)
  end

  def notify_failure(cause = nil)
    changed
    notify_observers(:failure, cause)
  end
end
