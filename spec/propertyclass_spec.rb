require 'property_helpers'


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
      Property[:p].should == p
    end

    it 'should not recognise an undeclared property' do
      lambda { Property.p }.should raise_error(NoMethodError)
      Property.respond_to?(:p).should be_false
      Property[:p].should be_nil
    end

    it 'should reject wrong argument number calls of properties' do
      p = declare_property_p
      lambda { Property.p(true) }.should raise_error(ArgumentError)
      Property[:p].should == p
    end

    it 'should assign correctly the documenting description' do
      property :p => String do |a|
        a.length > 0
      end
      doc = 'Property for testing purposes'
      desc doc
      property :q => [Object, Object] do |a, b|
        a & b
      end
      property :r => [Hash] do |a|
        !a.nil?
      end
      Property[:p].desc.should be_nil
      Property[:q].desc.should == doc
      Property[:r].desc.should be_nil
    end

    it 'should reject descriptions different than Strings' do
      lambda do
        desc 1
        property :p do end
      end.should raise_error(ArgumentError)
    end
  end
end
