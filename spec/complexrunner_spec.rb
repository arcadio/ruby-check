require 'cases'
require 'complexrunner'
require 'runner_helpers'


module ComplexRunnerSpec
  describe ComplexRunner do
    include RunnerHelpers

    it_should_behave_like 'Runner'

    def runner
      ComplexRunner.new(Cases.new)
    end
  end
end
