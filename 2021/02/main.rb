FORWARD = 'forward'
DOWN = 'down'
UP = 'up'

start = Time.now
input = File.readlines("input", chomp: true)
  .map{ |l|
    i = l.split(' ')
    i[1] = i[1].to_i
    i
  }
puts "Prep: #{Time.now - start}s"


start = Time.now

pos, depth = 0, 0
input.each do |op,x|
  case op
  when FORWARD
    pos += x
  when DOWN
    depth += x
  when UP
    depth -= x
  end
end

part1 = pos * depth
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now

pos, depth, aim = 0, 0, 0
input.each do |op,x|
  case op
  when FORWARD
    pos += x
    depth += aim * x
  when DOWN
    aim += x
  when UP
    aim -= x
  end
end

part2 = pos * depth
puts "Part 2: #{part2} (#{Time.now - start}s)"