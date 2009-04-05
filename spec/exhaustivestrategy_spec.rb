require 'exhaustive'
require 'property'
require 'strategy_helpers'


module ExhaustiveStrategySpec
  describe ExhaustiveStrategy do
    def strategy; ExhaustiveStrategy end

    describe ExhaustiveStrategy, 'when just built' do
      include StrategyHelpers

      it_should_behave_like 'NewStrategy'
    end


    describe ExhaustiveStrategy do
      it_should_behave_like 'Strategy'


      describe ExhaustiveStrategy, 'with a property that does not have any cases' do
        def define_prop
          property :p => [String, Range] do |a,b| end
        end

        it_should_behave_like 'PropertyWithoutCases'
      end


      describe ExhaustiveStrategy, 'with a property that has many cases' do
        def define_prop
          property :p => [String, String] do |a,b| end
        end

        it_should_behave_like 'PropertyWithCases'

        it '' do
        end
      end
    end
  end
end
