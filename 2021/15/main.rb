require_relative '../util/grid.rb'
require_relative '../util/astar.rb'

class Chiton < Grid

  attr_accessor :multiply

  def neighbours(cur)
    self.adj_coords(cur)
  end

  def heuristic(from, to)
    (from.first - to.first).abs + (from.last - to.last).abs
  end

  def distance(from, to)
    self[to]
  end

  def [](x, y = nil)
    return super(x, y) if @multiply.nil? || !(@multiply > 1)
    x, y = *x if x.is_a?(Array)

    mx, my = x / @col_count, y / @row_count
    x = x % @col_count if mx > 0 && mx < @multiply
    y = y % @row_count if my > 0 && my < @multiply

    v = super(x, y)
    unless v.nil?
      v = v + mx + my
      v = v - 9 if v > 9
    end
    v
  end

end


def calc(grid, multiply = 1)
  grid.multiply = multiply
  path = astar(grid, [0,0], [grid.col_count * multiply - 1, grid.row_count * multiply - 1])
  path[1..-1].map{ |c| grid[c] }.sum
end


start = Time.now
input = File.readlines("input", chomp: true).map{ |l| l.chars.map(&:to_i) }
grid = Chiton.new(input)
puts "Prep: #{Time.now - start}s"


start = Time.now
part1 = calc(grid)
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = calc(grid, 5)
puts "Part 2: #{part2} (#{Time.now - start}s)"