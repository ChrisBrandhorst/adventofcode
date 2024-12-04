require_relative '../util/time'
require_relative '../util/grid'

def prep
  input = File.readlines("input", chomp: true).map(&:chars)
  Grid.new(input, true)
end

def part1(grid)  
  deltas = [1,0,-1].repeated_permutation(2).to_a - [[0,0]]
  chars = "MAS".chars

  grid.select("X").sum do |c|
    deltas.count do |d|
      cc = c
      chars.all? do |v|
        cc = Grid.add(cc, d)
        grid[cc] == v
      end
    end
  end

end

def part2(grid)

  deltas = [
    [1, -1], [1, 1],
    [-1, 1], [-1, -1]
  ]
  orders = ["SSMM", "SMMS", "MMSS", "MSSM"]

  grid.select("A").count do |c|
    corners = deltas.map{ grid[Grid.add(c, _1)] }
    orders.include?(corners.join)
  end

end

grid = time("Prep", false){ prep }
time("Part 1"){ part1(grid) }
time("Part 2"){ part2(grid) }