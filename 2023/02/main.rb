start = Time.now
input = File.readlines("input", chomp: true)
  .map{ _1.split(": ").last.split("; ").map{ |c| c.split(", ").map{ |d| e = d.split(" "); [e.last.to_sym, e.first.to_i] }.to_h } }
puts "Prep: #{Time.now - start}s"


start = Time.now
MAXES = {red: 12, green: 13, blue: 14}
part1 = input.each_with_index.sum{ |g,i| g.any?{ |r| r.detect{ |k,v| v > MAXES[k] } } ? 0 : i + 1 }
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = input.sum{ |g| g.inject{|a,b| a.merge(b){ |_,s,t| [s,t].max } }.values.inject(&:*) }
puts "Part 2: #{part2} (#{Time.now - start}s)"