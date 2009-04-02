require 'batchui'
require 'runner'
require 'property'
require 'property_helpers'
require 'contract'


module SimpleRunnerSpec
  describe Runner do
    include PropertyHelpers

    it_should_behave_like 'Property'

    def define_prop
      property :a do true end

      property(:b) { false }

      property :c => [String, String] do
        predicate { |a, b| a.length > b.length }

        always_check ["aa", "a"], ["abc", "cde"]
      end

      property :d => [Object, Object] do
        predicate { |x, y| x != y }
      end

      [Property[:a], Property[:b], Property[:c], Property[:d]]
    end

    it 'should run all properties ' do
      r = Runner.new
      s = StringIO.new
      r.add_observer(UI.new(s))
      (PSet[*define_prop] | r).output
    end
  end
end
