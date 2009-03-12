require 'initializer'


class SimpleRunner
  attr_reader :properties

  def initialize(ui, *properties)
    unless properties.size == 0
      @properties = properties
    else
      @properties = Property.properties.values
    end
    @ui = ui.new(self)
    check
  end

  private

  def check
    properties.each do |p|
      sleep 2
      @ui.next_property(p)
      unless p.arity == 0

      else
        p.call ? @ui.success : @ui.failure
      end
    end
  end
end


# Example
load 'textui.rb'
load 'property_language.rb'

property :p do true end
property :q do false end
property :s do false end
s = SimpleRunner.new TextUI
