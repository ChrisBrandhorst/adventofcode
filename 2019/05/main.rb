require '../intcode/intcode'

input = File.read("input").split(",").map(&:to_i)

intcode = Intcode.new(input)

start = Time.now
part1 = intcode.with_input(1).run
puts "Part 1: #{part1} (#{Time.now - start}s)"

puts "\n"

start = Time.now
part2 = intcode.with_input(5).run
puts "Part 2: #{part2} (#{Time.now - start}s)"