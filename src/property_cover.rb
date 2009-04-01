require 'covertable'
require 'forwardable'
require 'property'


class Property
  extend Forwardable

  attr_accessor :covertable

  def_delegator :@covertable, :eval
end
