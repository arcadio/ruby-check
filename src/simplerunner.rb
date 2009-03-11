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
      sleep 0.5
      @ui.next_property(p)
      unless p.arity == 0
        #while ...
      else
        5.times { @ui.step_case; sleep 0.2 }
        p.call ? @ui.success : @ui.failure("Always false" * 100)
      end
    end
  end
end

load 'textui.rb'
load 'property_language.rb'


property :p do true end
property :q do false end
property :s do false end
s = SimpleRunner.new TextUI
sleep 2000
