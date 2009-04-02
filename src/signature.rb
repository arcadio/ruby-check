module Signature
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

  module_function :dump_signature, :dump_hash
end
