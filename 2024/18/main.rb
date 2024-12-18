require_relative '../util/time'
require_relative '../util/grid'
require_relative '../util/astar'

class Space < Grid

  include AStar

  def as_neighbours(current)
    self.adj_coords(current).select{ self[_1] != "#" }
  end
  def as_heuristic(neighbour, goal)
    (neighbour[0] - goal[0]).abs + (neighbour[1] + goal[1]).abs
  end
  def as_distance(cameFrom, current, neighbour)
    1
  end
  def as_at_goal?(current, goal)
    current == goal
  end
  def as_backtracks?(cameFrom, current, neighbour)
    cameFrom == neighbour
  end
  def as_reset!
    @seen = Set.new
  end
  def as_seen(current)
    @seen << current
  end
  def as_seen?(neighbour)
    @seen.include?(neighbour)
  end

end

def prep
  File.readlines("input", chomp: true).map{ _1.split(",").map(&:to_i) }
end

def build_space(bytes, max_bytes)
  size = bytes.flatten.max + 1
  points = (("." * size + "\n") * size).split("\n").map(&:chars)
  space = Space.new(points)
  bytes[0...max_bytes].each{ space[_1] = "#" }
  [space, [0,0], [size-1,size-1]]
end

def part1(bytes, max_bytes)
  space, start, fin = build_space(bytes, max_bytes)
  space.astar(start, fin).size - 1
end

def part2(bytes, max_bytes)
  l, r = max_bytes + 1, bytes.size - 1
  mem = []
  while l < r
    m = (l + r) / 2
    space, start, fin = build_space(bytes, m)
    mem[m] = !space.astar(start, fin).nil?
    if mem[m]
      l = m + 1
    else
      r = m - 1
    end
  end
  
  last = mem.rindex{ _1 == true }
  return bytes[last].join(",")
end

MAX_BYTES = 1024
bytes = time("Prep", false){ prep }
time("Part 1"){ part1(bytes, MAX_BYTES) }
time("Part 2"){ part2(bytes, MAX_BYTES) }