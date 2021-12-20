class InfiniteGrid

  attr_reader :min_x, :max_x
  attr_reader :min_y, :max_y
  attr_accessor :lookaround, :empty_value

  def initialize(rows, empty_value, lookaround = 1)
    @points = {}
    (0...rows.first.size).each do |y|
      (0...rows.size).each do |x|
        @points[[x,y]] = rows[y][x]
      end
    end

    @min_x, @max_x = 0, rows.size - 1
    @min_y, @max_y = 0, rows.first.size - 1
    @empty_value = empty_value
    @lookaround = lookaround
  end

  def [](x, y = nil)
    x = [x,y] unless x.is_a?(Array)
    @points[x] || @empty_value
  end

  def []=(x, y = nil, v)
    x, v = [x,y], v unless x.is_a?(Array)
    @min_x = x[0] if x[0] < @min_x
    @max_x = x[0] if x[0] > @max_x
    @min_y = x[1] if x[1] < @min_y
    @max_y = x[1] if x[1] > @max_y
    @points[x] = v
  end

  def each
    (@min_y-@lookaround..@max_y+@lookaround).each do |y|
      (@min_x-@lookaround..@max_x+@lookaround).each do |x|
        yield([x,y], self[x,y]) if block_given?
      end
    end
  end

  def adj(x, y = nil)
    x, y = *x if x.is_a?(Array)
    ad = [
      self[x-1,y-1],
      self[x,y-1],
      self[x+1,y-1],
      self[x-1,y],
      self[x,y],
      self[x+1,y],
      self[x-1,y+1],
      self[x,y+1],
      self[x+1,y+1]
    ]
  end

  def is_inside?(x, y = nil)
    x = [x,y] unless x.is_a?(Array)
    x[0] >= @min_x && x[0] <= @max_x && x[1] >= @min_y && x[1] <= @max_y
  end

  def flatten
    @points.values
  end

  def inspect
    (@min_y..@max_y).map do |y|
      (@min_x..@max_x).map do |x|
        self[x,y]
      end.join
    end.join("\n")
  end

end