require_relative '../util/time'
require_relative '../util/grid'
require 'set'

def prep
  input = File.readlines("input", chomp: true).map(&:chars)
  grid = Grid.new(input, true)
  antennas = grid.select{ _2 != "." }
    .group_by{ _2 }
    .map{ |k,v| [k,v.map(&:first)] }.to_h
  [grid, antennas]
end

def collect(grid, c, dx, dy, op, res, part2 = false)
  loop do
    c = [c[0].send(op, dx), c[1].send(op, dy)]
    grid[c] ? res << c : break
    break unless part2
  end
end

def antinodes(grid, antennas, part2 = false)
  antennas.inject(Set.new) do |res,(t,as)|
    as.combination(2).each do |k,l|
      dx, dy = k[0]-l[0], k[1]-l[1]
      collect(grid, part2 ? l : k, dx, dy, :+, res, part2)
      collect(grid, part2 ? k : l, dx, dy, :-, res, part2)
    end
    res
  end
end

grid, antennas = time("Prep", false){ prep }
time("Part 1"){ antinodes(grid, antennas).size }
time("Part 2"){ antinodes(grid, antennas, true).size }