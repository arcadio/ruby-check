require 'property'


module PropertySpec
  describe Property do
    before(:all) do
      Property.reset
    end

    after(:all) do
      Property.reset
    end

    it 'should accept a simple property with correct arity' do
      p = property :p1 => [String, String] do |a, b|
        a + b == (b + a).reverse
      end
      p.key.should == :p1
      p.types.should == [String, String]
      args = ["a", "b"]
      p.pred.call(*args).should be_true
      Property.p1(*args).should be_true
      Property.respond_to?(:p1).should be_true
    end

    it 'should accept a complex property with correct arity' do
      p = property :p2 => String do
        predicate { |a| a.length == a.size }
      end
      p.key.should == :p2
      p.types.should == [String]
      args = 'aa'
      p.pred.call(args).should be_true
      Property.p2(args).should be_true
      Property.respond_to?(:p2).should be_true
    end

    it 'should reject a simple property with incorrect arity' do
      lambda do
        property :p3 => [String] do |a, b|
          a + b == (b + a).reverse
        end
      end.should raise_error(ArgumentError)
    end

    it 'should reject a complex property with incorrect arity' do
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
      Property.p5.should be_true
      Property.respond_to?(:p5).should be_true
    end

    it 'should reject a property with a long hash in its signature' do
      lambda do
        property :p6 => String, :p7 => [String] do |a|
          a.length == a.size
        end
      end.should raise_error(ArgumentError)
    end

    it 'should not recognise an undeclared property' do
      lambda { Property.p9 }.should raise_error(NoMethodError)
      Property.respond_to?(:p9).should be_false
    end

    it 'should reject properties with non-Symbol values as keys' do
      lambda { property(1) {} }.should raise_error(ArgumentError)
      lambda { property(1 => String) {} }.should raise_error(ArgumentError)
    end

    it 'should reject properties without a defined predicate' do
      lambda { property(:p10 => String) {} }.should raise_error(ArgumentError)
    end

    it 'should reject wrong argument number calls of properties' do
      property :p11 => String do |a|
        a.length == a.size
      end
      lambda { Property.p11("a", "b") }.should raise_error(ArgumentError)
    end

    it 'should reject a property without a block' do
      lambda { property :p12 }.should raise_error(ArgumentError)
    end
  end
end
