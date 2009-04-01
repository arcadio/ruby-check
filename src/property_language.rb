require 'property'


module Kernel
  def desc(doc)
    Property.next_desc = doc
  end

  def property(signature, &block)
    Property.new(*dump_signature(signature), &block)
  end

  private

  def dump_signature(signature)
    if signature.is_a?(Hash)
      dump_hash(signature)
    else
      [signature, []]
    end
  end

  def dump_hash(hash)
    if hash.size != 1
      raise ArgumentError, 'incorrect property signature'
    end
    ary = hash.to_a
    types = ary.first.last
    [ary.first.first, types.is_a?(Array) ? types : [types]]
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
