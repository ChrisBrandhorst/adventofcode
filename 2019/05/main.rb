require '../intcode/intcode'

input = File.read("input").split(",").map(&:to_i)

intcode = Intcode.new(input)

start = Time.now
part1 = intcode.with_input(1).run.last_output
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = intcode.reset!.with_input(5).run.last_output
puts "Part 2: #{part2} (#{Time.now - start}s)"