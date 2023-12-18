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

route = [] +
  circle.first +
  circle[1,circle.size-2].map(&:first) +
  circle.last +
  circle[1,circle.size-2].map(&:last).reverse
route_set = Set.new(route)

cur = route.last
area = route.inject(0) do |a,c|
  xa, ya = cur
  xb, yb = cur = c
  a + ((ya+yb) / 2) * (xa-xb)
end

part2 = area.abs - route.size / 2 + 1
puts "Part 2: #{part2} (#{Time.now - start}s)"