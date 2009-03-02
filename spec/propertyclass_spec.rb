require 'property_helpers'
require 'property_language'


module PropertyClassSpec
  describe Property do
    include PropertyHelpers

    it_should_behave_like 'Property'

    def declare_property_p
      property :p => [Object, Object] do |a, b|
        a & b
      end
    end

    it 'should recognise a declared property' do
      p = declare_property_p
      Property.p(true, true).should be_true
      Property.p(true, false).should be_false
      Property.respond_to?(:p).should be_true
      Property[:p].should_not be_nil
    end

    it 'should not recognise an undeclared property' do
      lambda { Property.p }.should raise_error(NoMethodError)
      Property.respond_to?(:p).should be_false
      Property[:p].should be_nil
    end

    it 'should reject wrong argument number calls of properties' do
      declare_property_p
      lambda { Property.p(true) }.should raise_error(ArgumentError)
      Property[:p].should_not be_nil
    end
  end
end
