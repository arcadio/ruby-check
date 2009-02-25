require 'property'


module PropertySpec
  describe 'property' do
    it 'should accept a simple property with correct arity' do
      p = property :p1 => [String, String] do |a, b|
        a + b == (b + a).reverse
      end
      p.key.should == :p1
      p.types.should == [String, String]
      p.pred.call("a", "b").should be_true
    end

    it 'should accept a complex property with correct arity' do
      p = property :p2 => String do
        predicate { |a| a.length == a.size }
      end
      p.key.should == :p2
      p.types.should == [String]
      p.pred.call("aa").should be_true
    end

    it 'should not accept a simple property with incorrect arity' do
      lambda do
        property :p3 => [String] do |a, b|
          a + b == (b + a).reverse
        end
      end.should raise_error(ArgumentError)
    end

    it 'should not accept a complex property with incorrect arity' do
      lambda do
        property :p4 => [String] do |a, b|
          predicate { |a, b| a + b == (b + a).reverse }
        end
      end.should raise_error(ArgumentError)
    end

    it 'should accept a simple property with arity = 0' do
      p = property :p5 do
        1 > 0
      end
      p.key.should == :p5
      p.types.should == []
      p.pred.call.should be_true
    end
  end
end
