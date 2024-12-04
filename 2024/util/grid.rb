class Grid

  attr_reader :row_count, :col_count

  def initialize(rows)
    @rows = rows
    @row_count = @rows.size
    @col_count = @rows.map(&:size).max
    @with_diag = false
  end

  def with_diag!
    @with_diag = true
  end

  def row(y)
    @rows[y]
  end

  def col(x)
    (0...@row_count).map{ row(_1)[x] }
  end

  def [](x, y = nil)
    x, y = *x if x.is_a?(Array)
    x < 0 || y < 0 || x > @col_count - 1 || y > @row_count - 1 ? nil : @rows[y][x]
  end

  def []=(x, y = nil, v)
    x, y, v = *x, v if x.is_a?(Array)
    @rows[y][x] = v
  end

  def adj(x, y = nil)
    x, y = *x if x.is_a?(Array)
    ad = [
      self[x-1,y],
      self[x+1,y],
      self[x,y-1],
      self[x,y+1]
    ]

    if @with_diag
      ad += [
        self[x-1,y-1],
        self[x+1,y-1],
        self[x+1,y+1],
        self[x-1,y+1]
      ]
    end

    ad.compact
  end

  def adj_coords(x, y = nil)
    x, y = *x if x.is_a?(Array)
    ad = [
      self[x-1,y] ? [x-1,y] : nil,
      self[x+1,y] ? [x+1,y] : nil,
      self[x,y-1] ? [x,y-1] : nil,
      self[x,y+1] ? [x,y+1] : nil
    ]

    if @with_diag
      ad += [
        self[x-1,y-1] ? [x-1,y-1] : nil,
        self[x+1,y-1] ? [x+1,y-1] : nil,
        self[x+1,y+1] ? [x+1,y+1] : nil,
        self[x-1,y+1] ? [x-1,y+1] : nil
      ]
    end

    ad.compact
  end

  def each
    (0...@row_count).each do |y|
      (0...@col_count).each do |x|
        yield([x,y], self[x,y]) if block_given?
      end
    end
    self
  end

  def each_adj(x, y = nil)
    x, y = *x if x.is_a?(Array)
    self.adj_coords(x,y).each{ |c| yield(c, self[c]) if block_given? }
  end

  def inject(t)
    (0...@row_count).each do |y|
      (0...@col_count).each do |x|
        t = yield(t, [x,y], self[x,y]) if block_given?
      end
    end
    t
  end

  def select(&block)
    selected = []
    (0...@row_count).each do |y|
      (0...@col_count).each do |x|
        selected << [[x,y], self[x,y]] if block_given? && yield([x,y], self[x,y])
      end
    end
    selected
  end

  def detect(&block)
    (0...@row_count).detect do |y|
      (0...@col_count).detect do |x|
        return [x,y] if block_given? && yield([x,y], self[x,y])
      end
    end
  end

  def within?(x, y = nil)
    x, y = *x if x.is_a?(Array)
    x >= 0 && x < @col_count && y >= 0 && y < @row_count
  end

  def flatten
    @rows.flatten
  end

  def inspect
    @rows.map{ |r| r.join("") }.join("\n")
  end

  def self.add(c, d)
    [c[0] + d[0], c[1] + d[1]]
  end

end