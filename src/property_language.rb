require 'property_core'


def desc(doc)
  Property.next_desc = doc
end

def property(signature, &block)
  Property.new(signature, &block)
end
