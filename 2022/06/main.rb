require 'set'

def find_marker(input, c)
  input.each_cons(c).find_index{ _1.uniq.size == c } + c
end

start = Time.now
input = File.read("input").chars
puts "Prep: #{Time.now - start}s"

start = Time.now
part1 = find_marker(input, 4)
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = find_marker(input, 14)
puts "Part 2: #{part2} (#{Time.now - start}s)"