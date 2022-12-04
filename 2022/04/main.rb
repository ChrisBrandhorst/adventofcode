start = Time.now
input = File.readlines("input", chomp: true).map{ |i|
  i.split(",")
    .map{ |i| i.split("-").map(&:to_i) }
}
puts "Prep: #{Time.now - start}s"

start = Time.now
part1 = input.count{ |(a,b)| b.first <= a.first && b.last >= a.last || a.first <= b.first && a.last >= b.last }
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = input.count{ |(a,b)| b.first <= a.last && a.first <= b.last }
puts "Part 2: #{part2} (#{Time.now - start}s)"