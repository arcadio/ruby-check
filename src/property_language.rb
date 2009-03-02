require 'property_core'


def desc(doc)
  Property.next_desc = doc
end

def property(signature, &block)
  Property.new(signature, &block)
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
