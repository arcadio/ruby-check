require 'initializer'


class CaseRunner
  attr_reader :properties

  def initialize(ui, *properties)
    unless properties.size == 0
      @properties = properties
    else
      @properties = Property.properties.values
    end
    @ui = ui.new(self)
    check
  end

  private

  def check
    properties.each do |p|
      @ui.next_property(p)
      unless p.arity == 0
        cases = p.cases
        if cases
          i = 0
          failed = false
          while i < cases.size and !failed do
            @ui.step_case
            unless p.call(*cases[i])
              @ui.failure("Input #{cases[i].inspect}")
              failed = true
            end
            i += 1
          end
          @ui.success unless failed
        else
          @ui.failure 'No test cases provided'
        end
      else
        p.call ? @ui.success : @ui.failure
      end
    end
  end
end
