start = Time.now
input = File.readlines("input", chomp: true)
  .map{ |i| i.to_i(2) }
puts "Prep: #{Time.now - start}s"

start = Time.now

highest_bit = input.max.bit_length - 1
half = input.size.to_f / 2

ge = (0..highest_bit).inject([0,0]) do |(g,e),b|
  more_ones = input.count{ |i| i[b] == 1 } > half
  [ g + (more_ones ? 2**b : 0),
    e + (!more_ones ? 2**b : 0) ]
end

part1 = ge.inject(:*)
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now

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

ox = find_remaining(input)
co2 = find_remaining(input, true)
part2 = ox * co2
puts "Part 2: #{part2} (#{Time.now - start}s)"