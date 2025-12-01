class Dir

  attr_reader :dx, :dy

  def initialize(dx, dy)
    @dx = dx
    @dy = dy
  end

  def +(x, y = nil)
    x, y = *x if x.is_a?(Array)
    [x + dx, y + dy]
  end

  def self.each(&block)
    @dirs ||= [[0,-1],[1,0],[0,1],[-1,0]].map{ Dir.new(*_1) }
    @dirs.each{ |d| yield(d) } if block_given?
  end

end