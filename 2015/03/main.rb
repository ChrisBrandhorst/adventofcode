require 'set'

start = Time.now
input = File.read("input").chars
puts "Prep: #{Time.now - start}s"

def next_pos(pos, d)
  case d
  when "^"; [pos[0], pos[1] - 1]
  when "v"; [pos[0], pos[1] + 1]
  when ">"; [pos[0] + 1, pos[1]]
  when "<"; [pos[0] - 1, pos[1]]
  end
end


start = Time.now

pos = [0,0]
houses = Set.new

input.each do |d|
  pos = next_pos(pos, d)
  houses << pos
end

part1 = houses.size
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now

santa_pos = robo_pos = [0,0]
houses = Set.new

input.each_slice(2) do |sd, rd|
  santa_pos = next_pos(santa_pos, sd)
  robo_pos = next_pos(robo_pos, rd)
  houses << santa_pos
  houses << robo_pos
end

part2 = houses.size
puts "Part 2: #{part2} (#{Time.now - start}s)"