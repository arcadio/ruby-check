require 'curses'
require 'progressbar'
require 'scrollpane'


class TextUI
  include Curses

  def initialize
    @progressbar = ProgressBar.new(10)
    @scrollpane = ScrollPane.new
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
    @scrollpane.set_lines(0, status)
  end

  def print_error(error)
    @errorline += @scrollpane.set_lines(@errorline, error)
  end

  def status
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
    exit = false
    while !exit do
      c = getch
      Thread.exclusive do
        case c
        when KEY_UP, KEY_CTRL_P
          r = @scrollpane.scroll_up
        when KEY_DOWN, KEY_CTRL_N
          r = @scrollpane.scroll_down
        when ?q
          exit = true
          @scrollpane.close
        end
        beep if !r
      end
    end
  end
end


# c = TextUI.new
# a = ['a', 'b', 'c' , 'd', 'e', 'f', 'g', 'h', 'i', 'f']
# a.size.times do
#   c.step_property(a.shift)
#   5.times { c.step_case; sleep 0.2 }
#   if rand > 0.5
#     s = ""
#     e = "a"
#     40.times { s+= e + "\n"; e = e.next}
#     c.failure s
#   else
#     c.success
#   end
# end
# sleep 100
