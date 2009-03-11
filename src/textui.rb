require 'curses'
require 'progressbar'
require 'scrollpane'


class TextUI
  include Curses

  def initialize(runner)
    @runner = runner
    @progressbar = ProgressBar.new(runner.properties.size)
    @scrollpane = ScrollPane.new
    @failures = 0
    @slash = ' '
    @property = nil
    @errorline = 4
    update
    Thread.new { loop }
  end

  def step_case
    @slash = @slash == '/' ? '\\' : '/'
    update
  end

  def next_property(property)
    @property = property
    update
  end

  def success; step end

  def failure(cause = nil)
    @failures += 1
    print_error("\n#{@failures}. #{@property.key} failed\n#{cause}")
    step
  end

  private

  def update
    @scrollpane.set_lines(0, status)
  end

  def step
    @progressbar.step
    update
  end

  def print_error(error)
    @errorline += @scrollpane.set_lines(@errorline, error)
  end

  def status
    @progressbar.to_str + "\n" + case_line + "\n" + fails_line
  end

  def case_line
    if @progressbar.full
      'Finished'
    elsif @property.nil?
      ''
    else
      @slash + ' checking ' + @property.key.to_s
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
