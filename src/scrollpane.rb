require 'curses'
require 'lineutils'
require 'thread'


class ScrollPane
  include Curses, LineUtils

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
        r = line
        while !r.empty? do
          l, r = divide(r, @screen.maxx - 1)
          @buffer[index + i] = full_wide(l, @screen.maxx - 1)
          i += 1
        end
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
      puts @buffer
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

  def blank
    ' ' * (@screen.maxx - 1)
  end
end
