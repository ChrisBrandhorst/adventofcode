class Grid

  attr_reader :row_count, :col_count
  attr_reader :min_x, :max_x
  attr_reader :min_y, :max_y
  attr_reader :empty_value

  def initialize(rows, empty_value = '.')
    @row_count = rows.size
    @col_count = rows.first.size
    
    @points = {}
    (0...@row_count).each do |y|
      (0...@col_count).each do |x|
        @points[[x,y]] = rows[y][x] unless rows[y][x] == empty_value
      end
    end

    @min_x, @max_x = 0, rows.first.size - 1
    @min_y, @max_y = 0, rows.size - 1
    @with_diag = false
    @empty_value = empty_value
  end

  def with_diag!
    @with_diag = true
  end

  def [](x, y = nil)
    x = [x,y] unless x.is_a?(Array)
    @points[x] || @empty_value
  end

  def []=(x, y = nil, v)
    x, v = [x,y], v unless x.is_a?(Array)
    @points[x] = v
    @min_x = [x.first, @min_x].min
    @max_x = [x.first, @max_x].max
    @min_y = [x.last, @min_y].min
    @max_y = [x.last, @max_y].max
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

  def flatten
    @points.values
  end

  def inspect
    (@min_y..@max_y).map do |y|
      (@min_x..@max_x).map do |x|
        self[x,y] || @empty_value
      end.join
    end.join("\n")
  end

end