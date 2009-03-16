require 'pset'


module PSetSpec
  describe PSet do
    it 'should build a PSet when using []' do
      check_output(PSet[1])
    end

    it 'should build a PSet when using new and a block' do
      enum = [1, 2]
      block = lambda { |e| e + 1 }
      ps = PSet.new(enum, &block)
      check_output(ps)
      check_block(ps, enum, block)
    end

    it 'should build a PSet when using to_pset' do
      check_output([1, 2, 3].to_pset)
    end

    it 'should build a PSet when using to_pset and a block' do
      enum = [1, 2]
      block = lambda { |e| e + 1 }
      ps = [1, 2].to_pset &block
      ps.to_a.should == [2, 3]
      check_output(ps)
      check_block(ps, enum, block)
    end

    def check_output(ps)
      ps.output.should == ps
    end

    def check_block(ps, enum, block)
      enum.map(&block).should == ps.to_a
    end
  end
end
