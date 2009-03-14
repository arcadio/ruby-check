require 'covertable'


module CoverTableSpec
  describe CoverTable do
    TRUE = lambda { true }
    FALSE = lambda { false }

    before(:each) do
      @ct = CoverTable.new
    end

    after(:each) do
      @ct = nil
    end

    it 'should register correctly a coverage of size 1' do
      @ct.add(:e1, true)
      @ct.covered?.should be_false
      @ct.eval(:e1, :&, TRUE, TRUE).should be_true
      @ct.covered?.should be_true
    end

    it 'should register correctly a coverage of size 3' do
      @ct.add(:e1, true, false)
      @ct.add(:e2, true)
      @ct.covered?.should be_false
      @ct.eval(:e1, :&, TRUE, FALSE).should be_false
      @ct.covered?.should be_false
      @ct.eval(:e2, :|, FALSE, TRUE).should be_true
      @ct.covered?.should be_false
      @ct.eval(:e1, :&, TRUE, TRUE).should be_true
      @ct.covered?.should be_true
    end

    it 'should be resetted correctly' do
      @ct.add(:e1, true)
      @ct.add(:e2, false)
      @ct.covered?.should be_false
      @ct.eval(:e1, :&, TRUE, TRUE)
      @ct.eval(:e2, :|, FALSE, FALSE)
      @ct.covered?.should be_true
      @ct.reset!
      @ct.covered?.should be_false
      @ct.eval(:e1, :&, TRUE, TRUE)
      @ct.covered?.should be_false
      @ct.eval(:e2, :|, FALSE, FALSE)
      @ct.covered?.should be_true
    end
  end
end
