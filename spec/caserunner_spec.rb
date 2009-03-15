require 'batchui'
require 'caserunner'
require 'property_language'


module CaseRunnerSpec
  describe CaseRunner do
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
    end

    before(:each) do
      @prop_d = define_prop
    end

    after(:each) do
      Property.clear
      @prop_d = nil
    end

    it 'should run correctly one property' do
      CaseRunner.new([@prop_d], BatchUI, StringIO.new)
    end

    it 'should run correctly without specifying properties' do
      CaseRunner.new([], BatchUI, StringIO.new)
    end

    it 'should run correctly specifying nil properties and a generic UI' do
      CaseRunner.new(nil, UI, StringIO.new)
    end

    it 'should run correctly specifying properties with symbols and a generic UI' do
      CaseRunner.new([@prop_d, :a, :b], UI, StringIO.new)
    end
  end
end
