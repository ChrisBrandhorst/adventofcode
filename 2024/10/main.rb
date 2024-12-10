require_relative '../util/time'
require_relative '../util/grid'

def prep
  input = File.readlines("input", chomp: true).map{ _1.chars.map(&:to_i) }
  Grid.new(input)
end

def walks(grid)
  grid.select(0).map{ walk(grid, [_1]) }
end

def walk(grid, trail)
  last = trail.last
  last_v = grid[last]
  return [trail] if last_v == 9

  trails = []
  grid.each_adj(last) do |c,v|
    trails += walk(grid, trail + [c]) if v == last_v + 1
  end
  
  trails
end

def part1(walks)
  walks.sum{ _1.map(&:last).uniq.size }
end

def part2(walks)
  walks.sum(&:size)
end

grid = time("Prep", false){ prep }
walks = time("Walks", false){ walks(grid) }
time("Part 1"){ part1(walks) }
time("Part 2"){ part2(walks) }