digits = File.read("input").chars.map(&:to_i)

part1 = ([digits.last] + digits).each_cons(2).select{ _1 == _2 }.sum(&:first)
puts "Part 1: #{part1}"

part2 = digits.each_with_index.inject(0){ |s,(v,i)| s + (v == digits[i - digits.size / 2] ? v : 0) }
puts "Part 2: #{part2}"
