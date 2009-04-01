require 'blockinstrumenter'
require 'property_cover'
require 'property_helpers'
# fix require


module BlockInstrumenterSpec
  describe BlockInstrumenter do
    include PropertyHelpers

    it_should_behave_like 'Property'

    it 'should process correctly a simple property' do
      BlockInstrumenter.new(p = property(:p => [Object, Object]) { |a, b| a | b })
      p.covertable.covered?.should be_false
      p.call(true, true)
      p.covertable.covered?.should be_true
    end
  end
end
