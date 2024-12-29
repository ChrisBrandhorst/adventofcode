start = Time.now
input = File.readlines("input", chomp: true)
puts "Prep: #{Time.now - start}s"


start = Time.now
part1 = input.sum{ _1.size - _1.undump.size }
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = input.sum{ _1.dump.size - _1.size }
puts "Part 2: #{part2} (#{Time.now - start}s)"