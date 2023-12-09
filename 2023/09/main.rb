start = Time.now
input = File.readlines("input", chomp: true).map{ _1.split.map(&:to_i) }

all_diffs = input.map do |h|
  diffs = [h]
  diffs.unshift( diffs.first.each_cons(2).map{ _2-_1 } ) until diffs.first.all?{ _1 == 0 }
  diffs
end

puts "Prep: #{Time.now - start}s"


start = Time.now
part1 = all_diffs.sum{ _1.sum(&:last) }
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = all_diffs.sum{ _1.inject(0){ |s,v| v.first-s } }
puts "Part 2: #{part2} (#{Time.now - start}s)"