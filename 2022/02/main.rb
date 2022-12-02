start = Time.now
input = File.readlines("input", chomp: true)
  .map{ |i| [i[0].ord - 65, i[-1].ord - 88] }
puts "Prep: #{Time.now - start}s"

start = Time.now
part1 = input.sum{ |i| i.last + 1 + ((i.last - i.first + 1) % 3) * 3 }
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = input.sum{ |i| (i.first + (i.last - 1)) % 3 + 1 + i.last * 3 }
puts "Part 2: #{part2} (#{Time.now - start}s)"