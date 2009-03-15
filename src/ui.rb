require 'batchui'
require 'textui'


class UI
  def self.new(runner, output = nil)
    if Object.const_defined? :IRB or output
      BatchUI.new(runner, output)
    else
      TextUI.new(runner)
    end
  end
end
