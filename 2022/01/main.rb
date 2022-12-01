start = Time.now
$/*=2 # Set global line delimiter to \n\n
input = File.readlines("input")
  .map{ _1.split.sum(&:to_i) } # _1 is first argument of block. split works on \n
  .max(3)
puts "Prep: #{Time.now - start}s"

start = Time.now
part1 = input.first
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = input.sum
puts "Part 2: #{part2} (#{Time.now - start}s)"