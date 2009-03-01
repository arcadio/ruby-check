require 'property_class'


module PropertyHelpers
  shared_examples_for 'Property' do
    before(:each) do
      Property.reset
    end

    after(:each) do
      Property.reset
    end
  end
end
