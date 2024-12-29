start = Time.now
input = File.readlines("input", chomp: true)
puts "Prep: #{Time.now - start}s"


start = Time.now
part1 = input.count{ _1.scan(/[aeiou]/).size >= 3 && _1.match(/(.)\1+/) && !_1.match(/(ab|cd|pq|xy)/) }
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = input.count{ _1.match(/(..).*\1+/) && _1.match(/(.).\1+/) }
puts "Part 2: #{part2} (#{Time.now - start}s)"