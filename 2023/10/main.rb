require '../util/grid_points'
require 'set'


class MetalIsland < Grid
  PRETTY_PIPES = { "F": "╔", "L": "╚", "J": "╝", "7": "╗", "-": "═", "|": "║" }

  def connected_pipes(x, y = nil)
    x, y = *x if x.is_a?(Array)
    pipe = self[x,y]
    adj_coords = self.adj_coords(x,y)
    
    poss = []
    (0..3).each do |d|
      ac = adj_coords[d]
      case d
      when 0; poss << ac if ['S','|','L','J'].include?(pipe) && ['|','7','F'].include?(self[ac])
      when 1; poss << ac if ['S','-','F','L'].include?(pipe) && ['-','J','7'].include?(self[ac])
      when 2; poss << ac if ['S','|','7','F'].include?(pipe) && ['|','L','J'].include?(self[ac])
      when 3; poss << ac if ['S','-','J','7'].include?(pipe) && ['-','F','L'].include?(self[ac])
      end
    end
    poss
  end

  def adj_coords_loop(x, y = nil)
    x, y = *x if x.is_a?(Array)
    [
      [x,y-1],    # 0 T
      [x+1,y-1],  # 1 TR
      [x+1,y],    # 2 R
      [x+1,y+1],  # 3 BR
      [x,y+1],    # 4 B
      [x-1,y+1],  # 5 BL
      [x-1,y],    # 6 L
      [x-1,y-1],  # 7 TL
      [x,y-1]     # 8 T
    ]
  end

end


start = Time.now
input = File.readlines("input", chomp: true).map(&:chars)
island = MetalIsland.new(input)
animal_start = island.detect{ |c,v| v == "S" ? c : nil }.first
puts "Prep: #{Time.now - start}s"


start = Time.now
circle = [ [animal_start], island.connected_pipes(animal_start) ]
until circle.last.size == 1 do
  circle << new_parts = circle.last.map{ |s| (island.connected_pipes(s) - circle[-2]).first }.uniq
end
part1 = circle.size - 1
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now

# Calculate route
route = [] +
  circle.first +
  circle[1,circle.size-2].map(&:first) +
  circle.last +
  circle[1,circle.size-2].map(&:last).reverse
route_set = Set.new(route)

# Trace inside along route
insides = Set.new
CORNERS = {"7": 1, "J": 3, "L": 5, "F": 7}

# ⚠️ Pick interior
lpi = [animal_start[0], animal_start[1]-1]

# Get direction of route
first_c = island.detect{ |c,v| v == "F" && route_set.include?(c) }.first
second_c = route[route.index(first_c) + 1]
clock = second_c[0] > first_c[0] ? -1 : 1

route.each_cons(2) do |prev,cur|

  poss_insides = []
  cx, cy = cur
  dx, dy = cx - prev[0], cy - prev[1]
  adj_coords = island.adj_coords_loop(cx, cy)

  dir = 0
  case tile = island[cur]
  when "|"
    poss_insides << [lpi[0],lpi[1]+dy]
  when "-"
    poss_insides << [lpi[0]+dx,lpi[1]]
  else
    case tile
    when '7', 'L', 1, 5; dir = dy == -1 ? 1 : -1
    when 'J', 'F', 3, 7; dir = dx == -1 ? 1 : -1
    end
    i = CORNERS[tile.to_sym]
    poss_insides = adj_coords[i-1,3] if lpi == adj_coords[(i + 2 * dir * clock) % 8]
  end

  if poss_insides.empty?
    poss_insides << prev
    lpi = prev
  else
    lpi = poss_insides[dir]
  end

  poss_insides.each{ |ni| insides << ni if !route_set.include?(ni) }
end

# Flood fill from each inside tile
stack = insides.to_a
until stack.empty?
  island.each_adj(stack.shift) do |c,v|
    next if route_set.include?(c) || insides.include?(c)
    insides << c
    stack << c
  end
end

part2 = insides.size
puts "Part 2: #{part2} (#{Time.now - start}s)"


# route_set.each{ |c| island[c] = MetalIsland::PRETTY_PIPES[island[c].to_sym] }
# insides.each{ |c| island[c] = "I" }
# p island