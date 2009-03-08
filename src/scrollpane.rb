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
    Thread.new { loop }
  end

  def set_lines(index, lines)
    Thread.exclusive do
      i = 0
      lines.each_line do |e|
        self[index + i] = e
        i += 1
      end
      i
    end
  end

  def []=(index, line)
    Thread.exclusive do
      @buffer[index] = l(line)
      if index >= @top and index < @top + @screen.maxy
        repaint
      end
    end
  end

  def scroll_down
    Thread.exclusive do
      if @top + @screen.maxy < @buffer.size
        @top += 1
        repaint
      end
    end
  end

  def scroll_up
    Thread.exclusive do
      if @top > 0
        @top -= 1
        repaint
      end
    end
  end

  private

  def loop
    while true do
      c = getch
      Thread.exclusive do
        case c
        when KEY_UP
          scroll_up
        when KEY_DOWN
          scroll_down
        end
      end
    end
  end

  def repaint
    (0..@screen.maxy - 1).each do |e|
      @screen.setpos(e, 0)
      @screen.addstr(l(@buffer[@top + e]))
    end
    @screen.refresh
  end

  def l(line)
    if line
      l = line.strip
      l + ' ' * (@screen.maxx - 1 - l.length)
    else
      ' ' * (@screen.maxx - 1)
    end
  end
end

# s = ScrollPane.new
# t = 0
# i = 0
# 100.times do
#   #s.add_lines(i, "#{i}\n#{i+1}")
#   s[i] = "#{i}"
# #  sleep 0.1
#   i += 1
# end
# #sleep 100
# while true do
#   s[0] = "#{rand}"
#   s[1] = "#{rand}"
#   sleep 1
# end
