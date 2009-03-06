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

  def to_s
    pbar + ' ' + ratio
  end

  private

  def pbar
    blen = ((progress / total.to_r) * length).floor
    head = blen < length ? HEAD : ''
    bar = BODY * blen + head
    ENCLOSINGS.first + bar + ' ' * (length - bar.length) + ENCLOSINGS.last
  end

  def ratio
    "#{progress}/#{total}"
  end
end
