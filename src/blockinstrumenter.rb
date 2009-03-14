require 'property_core'
require 'rubygems'
require 'parse_tree'
require 'parse_tree_extensions'
require 'sexp_processor'
require 'ruby2ruby'


class BlockInstrumenter < SexpProcessor
  def initialize(property)
    super()
    self.auto_shift_type = true
    self.strict = false
    psexp = process(property.predicate.to_sexp)
    pcode = Ruby2Ruby.new.process(psexp)
    pblock = property.predicate.binding.eval(pcode)
    property.predicate(&pblock)

    # p b = .to_sexp
    # p t = process(b)
    # puts o = Ruby2Ruby.new.process(t)
  end

  def process_iter(exp)
    call = exp.shift
    asign = exp.shift
    body = process(exp.shift)
    s(:iter, call, asign, body)
  end

  def process_call(exp)
    target = exp.shift
    method = exp.shift
    args = exp.shift
    s(:call, target, method, args)
  end
end
