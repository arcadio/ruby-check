require 'property_helpers'


module PropertyLanguageSpec
  describe Kernel do
    it_should_behave_like 'Property'

    it 'should build a simple property with => notation' do
      p = property :p => [String, String] do |a, b|
        a == b
      end
      p.key.should == :p
      p.types.should == [String, String]
      p.call('a', 'a').should be_true
    end

    it 'should build a complex property' do
      p = property :p do
        false
      end
      p.key.should == :p
      p.types.should == []
      p.call.should be_false
    end

    it 'should build a simple property with => notation and without Array' do
      p = property :p => String do |a|
        a.length == 0
      end
      p.key.should == :p
      p.types.should == [String]
      p.call('').should be_true
    end

    it 'should reject a property with a long hash in its signature' do
      lambda do
        property :p1 => String, :p2 => [String] do |a|
          a.length == a.size
        end
      end.should raise_error(ArgumentError)
    end
  end


  describe TrueClass do
    it 'true => true = true' do
      (true.implies true).should be_true
    end

    it 'true => false = false' do
      (true.implies false).should be_false
    end
  end


  describe FalseClass do
    it 'false => true = true' do
      (false.implies true).should be_true
    end

    it 'false => false = true' do
      (false.implies false).should be_true
    end
  end
end
