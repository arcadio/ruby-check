require 'property_analyzer'


module AnalyzerSpec
  describe PropertyAnalyzer do
    before(:each) do
      Property.reset
    end

    after(:each) do
      Property.reset
    end

    it 'should process correctly a simple property' do
      Bool = nil
      PropertyAnalyzer.new(property :p => [Bool, Bool] do |a, b|
        a | b | c
      end)
    end
  end
end
