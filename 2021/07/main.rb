start = Time.now
input = File.read("input", chomp: true).split(',').map(&:to_i)
puts "Prep: #{Time.now - start}s"

start = Time.now
part1 = (input.min..input.max).map{ |h| input.sum{ |i| (h-i).abs } }.min
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = (input.min..input.max).map{ |h| input.sum{ |i| d = (h-i).abs; d*(d+1)/2 } }.min
puts "Part 2: #{part2} (#{Time.now - start}s)"