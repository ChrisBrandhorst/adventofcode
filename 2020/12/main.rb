INSTR_FORMAT = /(\w)(\d+)/
DIRS = { 0 => 'N', 90 => 'E', 180 => 'S', 270 => 'W' }

def move(point, op, n)
  case op
  when 'N'; point[:y] += n
  when 'S'; point[:y] -= n
  when 'E'; point[:x] += n
  when 'W'; point[:x] -= n
  end
end

start = Time.now
input = File.readlines("input")
  .map{ |l| l.match(INSTR_FORMAT).captures }
  .each{ |i| i[1] = i[1].to_i }
puts "Prep:   #{Time.now - start}s"

start1 = Time.now
dir, pos = 90, {x: 0, y: 0}
input.each do |op, n|
  case op
  when 'L'; dir = (dir - n) % 360
  when 'R'; dir = (dir + n) % 360
  else
    op = DIRS[dir] if op == 'F'
    move(pos, op, n)
  end
end
part1 = pos[:x].abs + pos[:y].abs
puts "Part 1: #{part1} (#{Time.now - start1}s)"

start2 = Time.now
wp, pos = {x: 10, y: 1}, {x: 0, y: 0}
input.each do |op,n|
  case op
  when 'F'
    pos[:x] += wp[:x] * n
    pos[:y] += wp[:y] * n
  when 'L', 'R'
    n = 360 - n if op == 'R'
    wp = case n
      when 90; { x: -wp[:y], y: wp[:x] }
      when 180; { x: -wp[:x], y: -wp[:y] }
      when 270; { x: wp[:y], y: -wp[:x] }
      end
  else
    move(wp, op, n)
  end
end
part2 = pos[:x].abs + pos[:y].abs
puts "Part 2: #{part2} (#{Time.now - start2}s)"

puts "Total:  #{Time.now - start}s"