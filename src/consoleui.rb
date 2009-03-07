require 'curses'
require 'progressbar'


class ConsoleUI
  include Curses

  def initialize
    crmode
    noecho
    np = 10
    @pb = ProgressBar.new(np)
    @fails = 0
    reset
  end

  def step_case
    @slash = @slash == '/' ? '\\' : '/'
    update
  end

  def step_property(property = nil)
    @property = property
    update
  end

  def success
    @pb.step
    update
  end

  def fail(cause)
    print_console(cause)
    @fails += 1
    @pb.step
    update
  end

  private

  def reset
    @slash = ' '
    @property = nil
    update
  end

  def update
    setpos(0, 0)
    addstr(str)
    refresh
  end

  def print_console(str)
    close_screen
    puts str
    crmode
    update
  end

  def str
    @pb.to_str + "\n" * 2 + case_line + "\n" * 2 + fails_line + "\n"
  end

  def case_line
    if @property.nil?
      ''
    else
      @slash + ' checking ' + @property
    end
  end

  def fails_line
    "#{@fails} failure(s)"
  end
end


c = ConsoleUI.new
a = ['a', 'b', 'c' , 'd', 'e', 'f', 'g', 'h', 'i']
a.size.times do
  c.step_property(a.shift)
  25.times { c.step_case; sleep 0.05 }
  if rand > 0.8
    c.fail 'a'
  else
    c.success
  end
end
