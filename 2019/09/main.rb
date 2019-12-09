require '../intcode/intcode'

input = File.read("input").split(",").map(&:to_i)

intcode = Intcode.new(input)

start = Time.now
part1 = intcode.verbose!.with_input(1).run.output
puts "Part 1: #{part1} (#{Time.now - start}s)"

puts "\n"

start = Time.now
part2 = intcode.reset!.with_input(2).run.output
puts "Part 2: #{part2} (#{Time.now - start}s)"