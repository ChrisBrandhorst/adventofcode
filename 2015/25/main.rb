start = Time.now
row, col = File.read("input", chomp: true).scan(/\d+/).map(&:to_i)
puts "Prep: #{Time.now - start}s"

start = Time.now
n = row + col - 1
i = (n - 1) * n / 2 + col
code = 20151125
(i - 1).times{ code = code * 252533 % 33554393 }
part1 = code
puts "Part 1: #{part1} (#{Time.now - start}s)"