require_relative '../util/infinite_grid.rb'

class ImageGrid < InfiniteGrid

  attr_reader :min_x, :max_x
  attr_reader :min_y, :max_y

  def initialize(rows)
    super(rows, '.', 3)
  end

  def adj_bin(x, y = nil)
    x, y = *x if x.is_a?(Array)
    pix = self.adj(x,y).map{ |a| a == '#' ? '1' : '0' }.join.to_i(2)
  end

  def step!(enhancement, reset_boundary = false)
    new_pix = {}
    self.each{ |c| new_pix[c] = enhancement[self.adj_bin(c)] }
    
    if reset_boundary
      @min_x += 1
      @max_x -= 1
      @min_y += 1
      @max_y -= 1
    end

    @points = {}
    new_pix.each{ |c,v| self[c] = v if !reset_boundary || self.is_inside?(c) }
  end

  def count_lit
    @points.count{ |k,v| v == '#' }
  end

end


def step(grid, enhancement, n)
  n.times { |i| grid.step!(enhancement, (i+1).even?) }
  grid.count_lit
end


start = Time.now
input = File.readlines("input", chomp: true)
enhancement = input[0]
data = input[2..-1].map{ |l| l.chars }
grid = ImageGrid.new(data)
puts "Prep: #{Time.now - start}s"


start = Time.now
part1 = step(grid, enhancement, 2)
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = step(grid, enhancement, 48)
puts "Part 2: #{part2} (#{Time.now - start}s)"