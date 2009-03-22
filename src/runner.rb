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

  def check(properties)
    properties.each do |p|
      notify_next(p)
      unless p.arity == 0
        cases = p.cases
        if cases
          i = 0
          failed = false
          while i < cases.size and !failed do
            notify_step
            unless p.call(*cases[i])
              notify_failure("Input #{cases[i].inspect}")
              failed = true
            end
            i += 1
          end
          notify_success unless failed
        else
          notify_failure('No test cases provided')
        end
      else
        p.call ? notify_success : notify_failure
      end
    end
  end

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
