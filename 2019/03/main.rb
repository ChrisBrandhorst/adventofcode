data = File.readlines("input").map{ |l| l.strip.split(",").map{ |i| [i[0], i[1..-1].to_i] } }

wires_pos = [
  [[0,0]],  # x,y
  [[0,0]]
]

def grow!(pts, dir, steps)
  steps.times do
    nxt = pts.last.clone
    case dir
    when "R"; nxt[0] += 1
    when "D"; nxt[1] -= 1
    when "L"; nxt[0] -= 1
    when "U"; nxt[1] += 1
    end
    pts << nxt
  end
end

data.each_with_index do |d,i|
  wire_pos = wires_pos[i]
  d.each{ |m| grow!(wire_pos, m[0], m[1]) }
end

intersections = wires_pos[0] & wires_pos[1]
intersections.shift

part1 = intersections.map{ |p| p.map(&:abs) }.map(&:sum).sort.first
puts "Part 1: #{part1}"

part2 = intersections.map{ |i| (wires_pos[0].index(i) + wires_pos[1].index(i)) }.min
puts "Part 2: #{part2}"