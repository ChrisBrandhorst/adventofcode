start = Time.now
input = File.readlines("input")
  .map{ |l| l.split(": ").last.split(" | ").map{ _1.split.map(&:to_i) }[0..-1].inject(&:&).size  }
puts "Prep: #{Time.now - start}s"


start = Time.now
part1 = input.sum{ _1 == 0 ? 0 : 2 ** (_1-1) }
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = (cc = [1]*input.size).each_with_index.sum{ |m,i| (1..input[i]).each{ cc[i+_1] += m }; m }
puts "Part 2: #{part2} (#{Time.now - start}s)"