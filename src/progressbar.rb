class ProgressBar
  DEFAULT_LENGTH = 50

  ENCLOSINGS = ['[', ']']

  HEAD = '>'

  BODY = '='

  FILL = ' '

  attr_reader :total, :progress, :length

  def initialize(total, length = DEFAULT_LENGTH)
    @total = total
    @length = length
    @progress = 0
  end

  def step
    raise 'Trying to step over the total' if progress == total
    @progress += 1
  end

  def to_str
    pbar + ' ' + ratio
  end

  private

  def pbar
    blen = ((progress / total.to_f) * length).floor
    head = blen < length ? HEAD : ''
    bar = BODY * blen + head
    ENCLOSINGS.first + bar + ' ' * (length - bar.length) + ENCLOSINGS.last
  end

  def ratio
    nc = total.to_s.length
    sprintf("%#{nc}d/%d", progress, total)
  end
end