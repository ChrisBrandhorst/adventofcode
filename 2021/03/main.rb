start = Time.now
lines = File.readlines("input", chomp: true)
highest_bit = lines.first.length - 1
input = lines.map{ |i| i.to_i(2) }
puts "Prep: #{Time.now - start}s"

start = Time.now

half = input.size.to_f / 2
part1 = (0..highest_bit).inject([0,0]) do |(g,e),b|
  more_ones = input.count{ |i| i[b] == 1 } > half
  [ g + (more_ones ? 2**b : 0),
    e + (!more_ones ? 2**b : 0) ]
end.inject(:*)
puts "Part 1: #{part1} (#{Time.now - start}s)"


def find_remaining(inp, find_least_common = false)
  b = inp.max.bit_length - 1
  while inp.size > 1
    keep = inp.count{ |i| i[b] == 1 } >= inp.size.to_f / 2 ? 1 : 0
    keep = 1 - keep if find_least_common
    inp = inp.select{ |i| i[b] == keep }
    b -= 1
  end
  inp.last
end

start = Time.now
part2 = find_remaining(input) * find_remaining(input, true)
puts "Part 2: #{part2} (#{Time.now - start}s)"





puts "== Alternative ==========="

start = Time.now
input = File.readlines("input", chomp: true)
  .map{ |i| i.chars }
puts "Prep: #{Time.now - start}s"

start = Time.now

half = input.size.to_f / 2
g = input.transpose.map{ |i| i.count("0") > half ? 0 : 1 }
part1 = g.join.to_i(2) * g.map{ |i| 1 - i }.join.to_i(2)

puts "Part 1: #{part1} (#{Time.now - start}s)"