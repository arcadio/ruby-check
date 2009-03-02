require 'property_language'


module PropertyLanguageSpec
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
