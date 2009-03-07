require 'curses'
require 'monitor'
require 'progressbar'
require 'scrollpane'
require 'thread'


class CursesUI
  include Curses

  attr_reader :scrollpane

  def initialize
    np = 10
    @progressbar = ProgressBar.new(np)
    @scrollpane = ScrollPane.new
    @scrollpane.extend MonitorMixin
    @failures = 0
    @slash = ' '
    @property = nil
    @errorline = 8
    update
    Thread.new { loop }
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
    @progressbar.step
    update
  end

  def failure(cause)
    print_error(cause)
    @failures += 1
    @progressbar.step
    update
  end

  private

  def update
    Thread.exclusive do
    i = 0
    str.each_line do |l|
      @scrollpane[i] = l
      i += 1
    end
    end
  end

  def print_error(str)
    Thread.exclusive do
    e = @errorline
    str.each_line do |l|
      @scrollpane[e] = l
      e += 1
    end
    @errorline = e
    end
  end

  def str
    @progressbar.to_str + "\n" + case_line + "\n" + fails_line
  end

  def case_line
    if @property.nil?
      ''
    else
      @slash + ' checking ' + @property
    end
  end

  def fails_line
    "#{@failures} failure(s)"
  end

  def loop
    term = false
    while !term do
      c = getch
      case c
      when KEY_DOWN
        Thread.exclusive do
        @scrollpane.scroll_down
        end
      when KEY_UP
        Thread.exclusive do
        @scrollpane.scroll_up
        end
      when ?q
        term = true
      end
    end
    close_screen
  end
end


c = CursesUI.new
a = ['a', 'b', 'c' , 'd', 'e', 'f', 'g', 'h', 'i', 'f']
a.size.times do
  c.step_property(a.shift)
  2.times { c.step_case; sleep 2 }
  if rand > 0.5
    s = ""
    e = "a"
    40.times { s+= e + "\n"; e = e.next}
    c.failure s
  else
    c.success
  end
end


