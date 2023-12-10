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
route_poss = Set.new(route)

# Trace inside along route
# ⚠️ ASSUMPTION
poss_insides = [[animal_start[0]-1, animal_start[1]]]
insides = Set.new
ADJ_T = 0; ADJ_TR = 1; ADJ_R = 2; ADJ_BR = 3; ADJ_B = 4; ADJ_BL = 5; ADJ_L = 6; ADJ_TL = 7

route.each_cons(2) do |prev,cur|
  lpi = poss_insides.last
  new_poss_insides = []
  cx, cy = cur
  dx, dy = cx - prev[0], cy - prev[1]

  adj_coords = [
    [cx,cy-1],    # 0 T
    [cx+1,cy-1],  # 1 TR
    [cx+1,cy],    # 2 R
    [cx+1,cy+1],  # 3 BR
    [cx,cy+1],    # 4 B
    [cx-1,cy+1],  # 5 BL
    [cx-1,cy],    # 6 L
    [cx-1,cy-1],  # 7 TL
    [cx,cy-1]     # 8 T
  ]

  case island[cur]
  when "7" # TR 1
    if dy == 0
      new_poss_insides = adj_coords[ADJ_TR-1,3]         if lpi == adj_coords[(ADJ_TR - 2) % 8]
    else
      new_poss_insides = adj_coords[ADJ_TR-1,3].reverse if lpi == adj_coords[(ADJ_TR + 2) % 8]
    end
  when "|"
    new_poss_insides << [lpi[0],lpi[1]+dy]
  when "J" # BR 3
    if dx == 0
      new_poss_insides = adj_coords[ADJ_BR-1,3]         if lpi == adj_coords[(ADJ_BR - 2) % 8]
    else
      new_poss_insides = adj_coords[ADJ_BR-1,3].reverse if lpi == adj_coords[(ADJ_BR + 2) % 8]
    end
  when "-"
    new_poss_insides << [lpi[0]+dx,lpi[1]]
  when "L" # BL 5
    if dy == 0
      new_poss_insides = adj_coords[ADJ_BL-1,3]         if lpi == adj_coords[(ADJ_BL - 2) % 8]
    else
      new_poss_insides = adj_coords[ADJ_BL-1,3].reverse if lpi == adj_coords[(ADJ_BL + 2) % 8]
    end
  when "F" #TL 7
    if dx == 0
      new_poss_insides = adj_coords[ADJ_TL-1,3]         if lpi == adj_coords[(ADJ_TL - 2) % 8]
    else
      new_poss_insides = adj_coords[ADJ_TL-1,3].reverse if lpi == adj_coords[(ADJ_TL + 2) % 8]
    end

  end

  new_poss_insides << prev if new_poss_insides.empty?

  new_poss_insides.each{ |ni| insides << ni if !route_poss.include?(ni) }
  poss_insides += new_poss_insides
end


stack = insides.to_a
until stack.empty?
  ri = stack.shift
  island.each_adj(ri) do |c,v|
    next if route_poss.include?(c) || insides.include?(c)
    insides << c
    stack << c
  end
end

part2 = insides.size
puts "Part 2: #{part2} (#{Time.now - start}s)"



# route_poss.each{ |c| island[c] = MetalIsland::PRETTY_PIPES[island[c].to_sym] }
# insides.each{ |c| island[c] = "I" }
# p island