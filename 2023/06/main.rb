start = Time.now
input = File.readlines("input", chomp: true)
  .map{ _1.split.map(&:to_i) }
  .transpose
  .drop(1)
puts "Prep: #{Time.now - start}s"


def race_bruteforce(rt, rd)
  (0..rt).count{ _1*(rt-_1) > rd }
end


def race_math(rt, rd)
  sq = Math.sqrt(rt**2 - 4*rd)
  ((-rt + sq) / 2).ceil - ((-rt - sq) / 2).floor - 1
end


start = Time.now
part1 = input.map{ race_bruteforce(_1, _2) }.inject(&:*)
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = race_math( *input.transpose.map{ _1.join.to_i } )
puts "Part 2: #{part2} (#{Time.now - start}s)"