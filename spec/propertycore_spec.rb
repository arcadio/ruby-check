require 'property_language'
require 'property_helpers'


module PropertySpec
  describe Property do
    include PropertyHelpers

    it_should_behave_like 'Property'

    it 'should accept a simple property with correct arity' do
      p = property :p => [String, String] do |a, b|
        a + b == (b + a).reverse
      end
      p.key.should == :p
      p.types.should == [String, String]
      args = ["a", "b"]
      p.pred.call(*args).should be_true
    end

    it 'should accept a complex property with correct arity' do
      p = property :p => String do
        predicate { |a| a.length == a.size }
      end
      p.key.should == :p
      p.types.should == [String]
      args = 'aa'
      p.pred.call(args).should be_true
    end

    it 'should reject a simple property with incorrect arity' do
      lambda do
        property :p => [String] do |a, b|
          a + b == (b + a).reverse
        end
      end.should raise_error(ArgumentError)
    end

    it 'should reject a complex property with incorrect arity' do
      lambda do
        property :p => [String] do |a, b|
          predicate { |a, b| a + b == (b + a).reverse }
        end
      end.should raise_error(ArgumentError)
    end

    it 'should accept a simple property with arity 0' do
      p = property :p do
        1 > 0
      end
      p.key.should == :p
      p.types.should == []
      p.pred.call.should be_true
    end

    it 'should reject a property with a long hash in its signature' do
      lambda do
        property :p1 => String, :p2 => [String] do |a|
          a.length == a.size
        end
      end.should raise_error(ArgumentError)
    end

    it 'should reject properties with non-Symbol values as keys' do
      lambda { property(1) {} }.should raise_error(ArgumentError)
      lambda { property(1 => String) {} }.should raise_error(ArgumentError)
    end

    it 'should reject properties without a defined predicate' do
      lambda { property(:p => String) {} }.should raise_error(ArgumentError)
    end

    it 'should reject a property without a block' do
      lambda { property :p }.should raise_error(ArgumentError)
    end
  end
end
