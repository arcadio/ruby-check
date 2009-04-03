require 'strategy'


module StrategyHelpers
  shared_examples_for 'Strategy' do
    before(:each) do
      @strategy = strategy.new
    end

    after(:each) do
      @strategy = nil
    end

    it 'should refuse to generate when just built' do
      lambda { @strategy.generate }.should raise_error
    end

    it 'should refuse to report if it is exhausted when just built' do
      lambda { @strategy.exhausted? }.should raise_error
    end

    it 'should refuse to report progress when just built' do
      lambda { @strategy.progress }.should raise_error
    end
  end
end
