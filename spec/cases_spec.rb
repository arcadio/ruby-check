require 'cases'
require 'property'
require 'strategy_helpers'


module CasesSpec
  describe Cases do
    def strategy; Cases end


    describe Cases, 'when just built' do
      include StrategyHelpers

      it_should_behave_like 'Strategy'
    end


    describe Cases do
      before(:each) do
        Property.clear
        @strategy = strategy.new
        @strategy.set_property(define_prop)
      end

      after(:each) do
        Property.clear
        @strategy = nil
      end


      describe Cases, 'with a property that does not have any' do
        def define_prop
          property :p => [String] do |e|
            e.length > 1
          end
        end

        it 'should refuse to generate' do
          lambda { @strategy.generate }.should raise_error
        end

        it 'should be exhausted' do
          @strategy.exhausted?.should be_true
        end

        it 'should have 0 progress' do
          @strategy.progress.should == 0
        end
      end


      describe Cases do
        shared_examples_for 'cases' do
          it 'should behave correctly when initialized' do
            @strategy.exhausted?.should be_false
            @strategy.progress.should == 0
          end
        end


        describe Cases, 'with a property that has one case' do
          def define_prop
            property :p => String do
              predicate { |s| s.length >= 0 }

              always_check ''
            end
          end

          it_should_behave_like 'cases'

          it 'should behave correctly when one case is generated' do
            @strategy.generate.should == ['']
            @strategy.exhausted?.should be_true
            @strategy.progress.should == 1
            lambda { @strategy.generate }.should raise_error
          end
        end


        describe Cases, 'with a property that has many cases' do
          def define_prop
            property :q => [String, String] do
              predicate { |s, t| s == t }

              always_check ['', ''], ['a', 'a'], ['b', 'b']
            end
          end

          it_should_behave_like 'cases'

          it 'should behave correctly when cases are generated' do
            @strategy.generate.should == ['', '']
            @strategy.exhausted?.should be_false
            @strategy.progress.should == 1.0/3
            @strategy.generate.should == ['a', 'a']
            @strategy.exhausted?.should be_false
            @strategy.progress.should == 2.0/3
            @strategy.generate.should == ['b', 'b']
            @strategy.exhausted?.should be_true
            @strategy.progress.should == 3/3
            lambda { @strategy.generate }.should raise_error
          end
        end
      end
    end
  end
end
