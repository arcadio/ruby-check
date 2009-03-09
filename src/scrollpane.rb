require 'curses'
require 'thread'


class ScrollPane
  include Curses

  def initialize
    @buffer = []
    @top = 0
    init_screen
    cbreak
    nonl
    noecho
    @screen = stdscr
    @screen.scrollok(true)
    @screen.keypad(true)
  end

  def set_lines(index, lines)
    Thread.exclusive do
      i = 0
      lines.each_line do |line|
        @buffer[index + i] = full_wide(line)
        i += 1
      end
      repaint
      i
    end
  end

  def scroll_up
    Thread.exclusive do
      if @top > 0
        @top -= 1
        repaint
        true
      else
        false
      end
    end
  end

  def scroll_down
    Thread.exclusive do
      if @top + @screen.maxy < @buffer.size
        @top += 1
        repaint
        true
      else
        false
      end
    end
  end

  def close
    Thread.exclusive do
      @screen.close
      close_screen
    end
  end

  private

  def repaint
    (0..@screen.maxy - 1).each do |e|
      @screen.setpos(e, 0)
      @screen.addstr(@buffer[@top + e] || blank)
    end
    @screen.refresh
  end

  def full_wide(line)
    line.strip + ' ' * (@screen.maxx - 1 - line.length)
  end

  def blank
    ' ' * (@screen.maxx - 1)
  end
end
