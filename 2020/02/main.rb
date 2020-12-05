RULE_FORMAT = /^(\d+)-(\d+) (\w): (\w+)$/

start = Time.now
input = File.readlines("input")
  .map{ |r| r.match(RULE_FORMAT).captures }
  .each{ |r| r[0] = r[0].to_i; r[1] = r[1].to_i }
puts "Prep: #{Time.now - start}s"

start = Time.now
part1 = input.map{ |r| c = r[3].count(r[2]); c >= r[0] && c <= r[1] }.count(true)
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = input.map{ |r| (r[3][r[0] - 1] == r[2]) ^ (r[3][r[1] - 1] == r[2]) }.count(true)
puts "Part 2: #{part2} (#{Time.now - start}s)"