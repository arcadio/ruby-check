require 'pipeline'
require 'set'


class PSet < Set
  include PipelineElement

  def initialize(enum = nil, &block)
    super
  end

  def output
    self
  end
end


module Enumerable
  def to_pset(*args, &block)
    to_set(PSet, *args, &block)
  end
end
