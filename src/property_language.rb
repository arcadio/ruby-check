require 'property_core'


def desc(doc); end

def property(signature, &block)
  Property.new(signature, &block)
end
