start = Time.now
input = File.read("input").chars.map{ _1 == "(" ? 1 : -1 }
puts "Prep: #{Time.now - start}s"


start = Time.now
part1 = input.sum
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = (0...input.size).inject(0){ |f,i| f += input[i]; break(i + 1) if f == -1; f }
puts "Part 2: #{part2} (#{Time.now - start}s)"