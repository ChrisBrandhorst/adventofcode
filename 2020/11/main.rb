FLOOR = '.'
EMPTY = 'L'
OCCUP = '#'

class Grid

  attr_reader :grid

  def initialize(grid)
    @grid = grid
  end

  def get(x, y)
    y < 0 || x < 0 ? nil : (@grid[y] || [])[x]
  end
  alias_method :[], :get

  def set(x, y, v)
    @grid[y][x] = v
  end
  alias_method :[]=, :set

  def adjecent(x, y, d = 1)
    [
      get(x + d, y),
      get(x, y + d),
      get(x + d, y + d),
      get(x - d, y - d),
      get(x, y - d),
      get(x + d, y - d),
      get(x - d, y),
      get(x - d, y + d)
    ]
  end
  alias_method :adj, :adjecent
  alias_method :neighbours, :adjecent

  def count(i)
    @grid.flatten.count(i)
  end

  def to_s
    @grid.map(&:join).join("\n")
  end

end

class SeatLayout < Grid

  FLOOR = '.'
  EMPTY = 'L'
  OCCUP = '#'

  attr_reader :changed

  def changed?
    @changed
  end

  def visible(x, y)
    vis = [nil] * 8
    1.step do |d|
      ring = adjecent(x, y, d)
      break if ring.all?(nil)

      ring.each_with_index{ |s,i| vis[i] = s if vis[i].nil? && (s == OCCUP || s == EMPTY) }
      break if !vis.any?(nil)
    end
    vis
  end

  def evolve!
    @changed = false

    new_grid = []
    (0..@grid.size-1).each do |y|
      (0..@grid[y].size-1).each do |x|
        new_grid[y] ||= []
        n = evolve_seat(x, y)
        new_grid[y][x] = n
        @changed = true if get(x, y) != n
      end
    end

    @grid = new_grid
    changed?
  end

  def evolve_seat(x, y)
    s = get(x, y)
    return s if s == FLOOR

    adj = lookaround(x, y)

    if s == EMPTY && !adj.include?(OCCUP)
      OCCUP
    elsif s == OCCUP && adj.count(OCCUP) >= occupied_limit
      EMPTY
    else
      s
    end
  end

  def lookaround(x, y); adjecent(x, y); end
  def occupied_limit; 4; end

end

class SeatLayout2 < SeatLayout
  def lookaround(x, y); visible(x, y); end
  def occupied_limit; 5; end
end

start = Time.now
input = File.readlines("input", chomp: true).map{ |l| l.split('') }
puts "Prep:   #{Time.now - start}s"

start1 = Time.now
grid = SeatLayout.new(input)
loop while grid.evolve!
part1 = grid.count(OCCUP)
puts "Part 1: #{part1} (#{Time.now - start1}s)"

start2 = Time.now
grid = SeatLayout2.new(input)
loop while grid.evolve!
part2 = grid.count(OCCUP)
puts "Part 2: #{part2} (#{Time.now - start2}s)"

puts "Total:  #{Time.now - start}s"