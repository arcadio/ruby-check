require 'property_helpers'
require 'contract'


module ContractSpec
  describe Contract do
    include PropertyHelpers

    it_should_behave_like 'Property'

    it 'should build a simple contract' do
      precondition = lambda { |n| n >= 0 }
      postcondition = lambda { |n,r| (r ** 2 - n).abs < 1e-5 }
      method = Math.method(:sqrt)
      c = Contract.new(method, [Float], precondition, postcondition)
      c.method.should == method
      c.precondition.should == precondition
      c.postcondition.should == postcondition
    end

    it 'should reject a contract with mismatching types' do
      precondition = lambda { |n| n >= 0 }
      postcondition = lambda { |n,r| (r ** 2 - n).abs < 1e-5 }
      method = Math.method(:sqrt)
      lambda do
        Contract.new(method, [], precondition, postcondition)
      end.should raise_error(ArgumentError)
    end
  end
end
