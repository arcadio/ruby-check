require 'runner'


class SimpleRunner < SequentialRunner

  private

  def check_property(p)
    cases = p.cases
    if cases
      i = 0
      failed = false
      while i < cases.size and !failed do
        notify_step
        failed = !eval_property(p, cases[i])
        i += 1
      end
      notify_success unless failed
    else
      notify_failure('No test cases provided')
    end
  end
end
