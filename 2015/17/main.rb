start = Time.now
input = File.readlines("input", chomp: true).map(&:to_i)
puts "Prep: #{Time.now - start}s"


start = Time.now
combinations = (0..input.size).flat_map{ |s| input.combination(s).map{ [_1.size, _1.sum] } }
targets = combinations.select{ _1.last == 150 }
part1 = targets.size
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
min = targets.map(&:first).min
part2 = targets.count{ _1.first == min }
puts "Part 2: #{part2} (#{Time.now - start}s)"