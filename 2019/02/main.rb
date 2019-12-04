require '../intcode/intcode'

input = File.read("input").split(",").map(&:to_i)

intcode = Intcode.new(input)

start = Time.now
part1 = intcode.run(12, 2)
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = nil
(0..99).each do |v|
  (0..99).each do |n|
    if intcode.run(n, v) == 19690720
      part2 = 100 * n + v
      break
    end
  end
  break if !part2.nil?
end
puts "Part 2: #{part2} (#{Time.now - start}s)"