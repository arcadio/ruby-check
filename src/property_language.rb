require 'property'
require 'signature'


module Kernel
  def desc(doc)
    Property.next_desc = doc
  end

  def property(signature, &block)
    Property.new(*Signature::dump_signature(signature), &block)
  end
end


class TrueClass
  def implies(conseq)
    !(conseq.nil? or conseq == false)
  end
end


class FalseClass
  def implies(conseq)
    true
  end
end
