require 'batchui'
require 'simplerunner'
require 'property_helpers'


module SimpleRunnerSpec
  describe SimpleRunner do
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

      property(:e) { raise nil }

      property :f => String do
        predicate { |s| s.length >= 0 }

        always_check '', nil, 'a'
      end

      [Property[:a], Property[:b], Property[:c], Property[:d], Property[:e],
      Property[:f]]
    end

    it 'should run all properties with cases correctly' do
      r = SimpleRunner.new
      s = StringIO.new
      r.add_observer(UI.new(s))
      (PList[*define_prop] | r).output
      s.string.should ==
        "Checking 6 properties\n" +
        "a\n" +
        "Success\n" +
        "b\n" +
        "Failure\n" +
        "c\n" +
        "..Failure\n" +
        "Input [\"abc\", \"cde\"]\n" +
        "d\n" +
        "Failure\n" +
        "No test cases provided\n" +
        "e\n" +
        "Failure\n" +
        "Unhandled exception object expected\n" +
        "f\n" +
        "..Failure\n" +
        "Input [nil]\n" +
        "Unhandled undefined method `length' for nil:NilClass\n"
    end
  end
end
