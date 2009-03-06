require 'progressbar'


module ProgressBarSpec
  describe ProgressBar do
    before(:each) do
      @pb = ProgressBar.new(5, 3)
    end

    after(:each) do
      @pb = nil
    end

    it 'should be empty initially' do
      @pb.to_s.should == '[>  ] 0/5'
    end

    it 'should progress adequately' do
      3.times { @pb.step }
      @pb.to_s.should == '[=> ] 3/5'
    end

    it 'should not be full until the total has been reached' do
      4.times { @pb.step }
      @pb.to_s.should == '[==>] 4/5'
    end

    it 'should be full when the total has been reached' do
      5.times { @pb.step }
      @pb.to_s.should == '[===] 5/5'
    end

    it 'should reject stepping over the total' do
      lambda do
        6.times { @pb.step }
      end.should raise_error(RuntimeError)
    end
  end
end
