require '../intcode/intcode'

input = File.read("input").split(",").map(&:to_i)

intcode = Intcode.new(input)

start = Time.now
part1 = intcode.with_nv(12,2).run[0]
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = nil
(0..99).each do |v|
  (0..99).each do |n|
    if intcode.reset!.with_nv(n,v).run[0] == 19690720
      part2 = 100 * n + v
      break
    end
  end
  break if !part2.nil?
end
puts "Part 2: #{part2} (#{Time.now - start}s)"