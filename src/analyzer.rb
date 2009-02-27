require 'property'
require 'rubygems'
require 'parse_tree'
require 'sexp_processor'


class PropertyAnalyzer < SexpProcessor
  def initialize(property)
    super()
    # self.strict = false
    self.auto_shift_type = true
    process(ParseTree.new.parse_tree_for_proc(property.pred))
  end

  def process_iter(exp)
    require 'pp'
    # puts 'iter'
    exp.shift
    exp.shift
    e = exp.shift
    # pp e
    process e
    s()
  end

  def process_block(exp)
    # puts 'block'
    while !exp.empty?
      process exp.shift
    end
    s()
  end

  def process_call(exp)
    # puts 'call'
    process exp.shift
    exp.shift # op
    process exp.shift
    s()
  end

  def process_dvar(exp)
    # puts 'dvar'
    exp.shift
    s()
  end

  def process_array(exp) # call params
    # puts 'array'
    process exp.shift
    s()
  end
end
