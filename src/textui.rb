require 'curses'
require 'progressbar'
require 'scrollpane'


class TextUI
  def initialize
    np = 10
    @progressbar = ProgressBar.new(np)
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
    @scrollpane.set_lines(0, str)
  end

  def print_error(s)
    @errorline += @scrollpane.set_lines(@errorline, s)
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
      c = Curses.getch
      case c
      when Curses::KEY_DOWN
        @scrollpane.scroll_down
      when Curses::KEY_UP
        @scrollpane.scroll_up
      when ?q
        term = true
      end
    end
    Curses.close_screen
  end
end


c = TextUI.new
a = ['a', 'b', 'c' , 'd', 'e', 'f', 'g', 'h', 'i', 'f']
a.size.times do
  c.step_property(a.shift)
  20.times { c.step_case; sleep 0.2 }
  if rand > 0.5
    s = ""
    e = "a"
    40.times { s+= e + "\n"; e = e.next}
    c.failure s
  else
    c.success
  end
end
sleep 100

  # def update
  #   i = 0
  #   str.each_line do |l|
  #     @scrollpane[i] = l
  #     i += 1
  #   end
  # end

  # def print_error(str)
  #   e = @errorline
  #   str.each_line do |l|
  #     @scrollpane[e] = l
  #     e += 1
  #   end
  #   @errorline = e
  # end
