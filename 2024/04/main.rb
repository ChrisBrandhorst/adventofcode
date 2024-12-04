require_relative '../util/time'
require_relative '../util/grid'

def prep
  input = File.readlines("input", chomp: true).map(&:chars)
  grid = Grid.new(input)
  grid.with_diag!
  grid
end

def part1(grid)
  
  deltas = [
    [0, -1],
    [1, -1],
    [1, 0],
    [1, 1],
    [0, 1],
    [-1, 1],
    [-1, 0],
    [-1, -1]
  ]

  options = []
  grid.each do |c,v|
    deltas.each{ options << {:c => c, :d => _1} } if v == "X"
  end

  options.count do |opt|
    "MAS".chars.inject(true) do |r,v|
      opt[:c] = Grid.add(opt[:c], opt[:d])
      grid[opt[:c]] != v ? (break false) : true
    end
  end

end

def part2(grid)

  deltas = [
    [1, -1],
    [1, 1],
    [-1, 1],
    [-1, -1]
  ]
  orders = ["SSMM", "SMMS", "MMSS", "MSSM"]

  grid.select{ _2 == "A" }.count do |c, v|
    corners = deltas.map{ grid[Grid.add(c, _1)] }
    orders.include?(corners.join)
  end

end

grid = time("Prep", false){ prep }
time("Part 1"){ part1(grid) }
time("Part 2"){ part2(grid) }