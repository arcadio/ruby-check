require 'blockinstrumenter'
require 'property_helpers'


module AnalyzerSpec
  describe BlockInstrumenter do
    include PropertyHelpers

    it_should_behave_like 'Property'

    it 'should process correctly a simple property' do
      BlockInstrumenter.new(property :p => [Object, Object] do |a, b|
        a | b | c
      end)
    end
  end
end
