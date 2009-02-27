require 'analyzer'


module AnalyzerSpec
  describe PropertyAnalyzer do
    before(:each) do
      Property.reset
    end

    after(:each) do
      Property.reset
    end

    it 'should process correctly a simple property' do
      PropertyAnalyzer.new(property :p => [String] do |a|
        l = a.length
        l >= 0
      end)
    end
  end
end
