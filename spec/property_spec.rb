require 'property'


module PropertySpec
  describe 'property' do
    it 'should accept a simple property with correct arity' do
      property :p1, [String, String] do |a, b|
        a + b == (b + a).reverse
      end
    end

    it 'should accept a simple property with arity = 0' do
      property :p2 do
        1 > 0
      end
    end

    it 'should accept a complex property with correct arity' do
      property :p3, [String, String] do
        predicate { |a, b| a + b == (b + a).reverse }
      end
    end

    it 'should not accept a simple property with incorrect arity' do
      lambda do
        property :p4, [String] do |a, b|
          a + b == (b + a).reverse
        end
      end.should raise_error(ArgumentError)
    end
  end
end
