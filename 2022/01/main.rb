start = Time.now
input = File.readlines("input", chomp: true)
  .map(&:to_i)
  .slice_before{ |i| i == 0 }
  .map(&:sum)
  .sort
puts "Prep: #{Time.now - start}s"

start = Time.now
part1 = input.last
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = input.last(3).sum
puts "Part 2: #{part2} (#{Time.now - start}s)"