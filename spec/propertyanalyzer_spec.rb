require 'property_analyzer'
require 'property_helpers'


module AnalyzerSpec
  describe PropertyAnalyzer do
    include PropertyHelpers

    it_should_behave_like 'Property'

    it 'should process correctly a simple property' do
      Bool = nil
      PropertyAnalyzer.new(property :p => [Bool, Bool] do |a, b|
        a | b | c
      end)
    end
  end
end
