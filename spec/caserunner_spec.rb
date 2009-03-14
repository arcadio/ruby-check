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
      $stdout = StringIO.new
      @d = define_prop
    end

    after(:each) do
      Property.clear
      @d = nil
      $stdout = STDOUT
    end

    it 'should run correctly one property' do
      CaseRunner.new(BatchUI, @d)
    end

    it 'should run correctly without specifying properties' do
      CaseRunner.new(BatchUI)
    end
  end
end
