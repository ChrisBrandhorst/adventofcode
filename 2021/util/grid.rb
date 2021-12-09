class Grid

  attr_reader :row_count, :col_count

  def initialize(rows)
    @rows = rows
    @row_count = @rows.size
    @col_count = @rows.first.size
  end

  def row(y)
    @rows[y]
  end

  def [](x, y = nil)
    x, y = *x if x.is_a?(Array)
    x < 0 || y < 0 || x > @col_count - 1 || y > @row_count - 1 ? nil : @rows[y][x]
  end

  def []=(x, y = nil, v)
    x, y = *x if x.is_a?(Array)
    @rows[y][x] = v
  end

  def each
    (0...@col_count).each do |y|
      (0...@row_count).each do |x|
        yield([x,y], self[x,y]) if block_given?
      end
    end
    self
  end

  def inject(t)
    (0...@col_count).each do |y|
      (0...@row_count).each do |x|
        t = yield(t, [x,y], self[x,y]) if block_given?
      end
    end
    t
  end

  def adj(x, y = nil)
    x, y = *x if x.is_a?(Array)
    [
      self[x-1,y],
      self[x+1,y],
      self[x,y-1],
      self[x,y+1]
    ].compact
  end

  def adj_coords(x, y = nil)
    x, y = *x if x.is_a?(Array)
    [
      self[x-1,y] ? [x-1,y] : nil,
      self[x+1,y] ? [x+1,y] : nil,
      self[x,y-1] ? [x,y-1] : nil,
      self[x,y+1] ? [x,y+1] : nil
    ].compact
  end

  def flatten
    @rows.flatten
  end

  def inspect
    @rows.map{ |r| r.join("") }.join("\n")
  end

end