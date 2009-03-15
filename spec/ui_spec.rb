require 'batchui'
require 'textui'
require 'ui'


module UISpec
  describe UI do
    before(:each) do
      @stub = mock('runner', :properties => {:a => nil, :b => nil})
    end

    after(:each) do
      @stub = nil
    end

    it 'should create a BatchUI when the output is specified' do
      UI.new(@stub, StringIO.new).class.should == BatchUI
    end

    it 'should not interfere with BatchUI#new' do
      BatchUI.new(@stub).class.should == BatchUI
    end
  end
end
