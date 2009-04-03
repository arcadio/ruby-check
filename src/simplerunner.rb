require 'runner'


class SimpleRunner < Runner

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
end
