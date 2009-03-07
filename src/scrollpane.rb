require 'curses'


class ScrollPane
  include Curses

  attr_reader :buffer

  def initialize
    @buffer = []
    @top = 0
    init_screen
    nonl
    cbreak
    noecho
    @screen = stdscr
    @screen.scrollok(true)
    @screen.keypad(true)
  end

  def []=(index, line)
    @buffer[index] = line.strip
    if index >= @top and index < @top + @screen.maxy
      @screen.setpos(index, 0)
      @screen.addstr(line.strip)
      @screen.refresh
    end
  end

  def scroll_up
    if @top > 0
      @screen.scrl(-1)
      @top -= 1
      str = @buffer[@top]
      if str
        @screen.setpos(0, 0)
        @screen.addstr(str)
      end
      #@screen.refresh
      true
    else
      false
    end
  end

  def scroll_down
    if @top + @screen.maxy < @buffer.size
      @screen.scrl(1)
      @top += 1
      str = @buffer[@top + @screen.maxy - 1]
      if str
        @screen.setpos(@screen.maxy - 1, 0)
        @screen.addstr(str)
      end
      #@screen.refresh
      true
    else
      false
    end
  end
end
