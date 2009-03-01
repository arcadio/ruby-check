require 'property_language'


module PropertyCasesSpec
  describe Property do

    it 'should accept simple sequence of cases to be checked' do
      property :p => String do
        predicate { |s| s.size == s.length }

        always_check '', "\\\?"
      end
      Property[:p].cases.should == ['', "\\\?"]
    end
  end
end
