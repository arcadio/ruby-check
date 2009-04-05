require 'exhaustive'
require 'set'


module ExhaustiveStringSpec
  describe String do
    it 'should compute all strings of size 0 correctly' do
      String.exhaustive(0).entries.should == ['']
    end

    it 'should compute all strings of size 1 correctly' do
      String.exhaustive(1).entries.should ==
        (0..127).map { |e| e.chr }
    end

    it 'should compute all strings of size 2 correctly' do
      strs = String.exhaustive(2).entries.to_set
      strs.size.should == 128 ** 2
      strs.each { |s| s.size.should == 2 }
    end
  end
end
