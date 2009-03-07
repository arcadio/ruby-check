require 'property_core'
require 'rubygems'
require 'parse_tree'
require 'sexp_processor'


class PropertyAnalyzer < SexpProcessor
  def initialize(property)
    super()
    # self.strict = false
    self.auto_shift_type = true
    process(ParseTree.new.parse_tree_for_proc(property.predicate))
  end

  def process_iter(exp)
    exp.shift # call proc
    exp.shift # masgn params
    process exp.shift # body
    s()
  end

  def process_block(exp)
    while !exp.empty?
      process exp.shift
    end
    s()
  end

  def process_call(exp)
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
