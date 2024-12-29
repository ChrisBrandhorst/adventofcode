start = Time.now
input = File.readlines("input", chomp: true).map{ _1.split("x").map(&:to_i) }
puts "Prep: #{Time.now - start}s"


start = Time.now
part1 = input.map{ |b| [ b[0]*b[1], b[1]*b[2], b[2]*b[0] ] }.sum{ _1.sum * 2 + _1.min }
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = input.sum{ |b| b.sort[0,2].sum * 2 + b.inject(&:*) }
puts "Part 2: #{part2} (#{Time.now - start}s)"