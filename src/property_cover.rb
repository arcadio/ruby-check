require 'covertable'
require 'forwardable'


class Property
  extend Forwardable

  attr_accessor :covertable

  def_delegator :@covertable, :eval
end
