require 'property_core'
require 'rubygems'
require 'parse_tree'
require 'parse_tree_extensions'
require 'ruby2ruby'


class BlockInstrumenter < SexpProcessor
  def initialize(property)
    super()
    self.auto_shift_type = true
    self.strict = false
    @property = property
    property.covertable = CoverTable.new
    sp = property.predicate.to_sexp
    # p sp #
    psexp = pproc_body(sp)
    # p psexp #
    pcode = Ruby2Ruby.new.process(psexp)
    pblock = property.predicate.binding.eval(pcode)
    property.predicate(&pblock)
  end

  def process_call(exp)
    @property.covertable.add(:e1, true)
    a1 = wrap_proc(exp.shift)
    op = exp.shift
    a2 = wrap_proc(exp.shift)
    s(:call,
      s(:call, s(:const, :Property), :[], s(:arglist, s(:lit, @property.key))),
      :eval,
      s(:arglist, s(:lit, :e1), s(:lit, op), a1, a2))
  end

  private

  def pproc_body(exp)
    exp.shift
    call = exp.shift
    asign = exp.shift
    body = process(exp.shift)
    s(:iter, call, asign, body)
  end

  def wrap_proc(body)
    s(:iter, s(:call, nil, :proc, s(:arglist)), nil, body)
  end
end
