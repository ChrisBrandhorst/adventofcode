def get_id(bp)
  bp[0..6].to_i(2) * 8 + bp[7..9].to_i(2)
end

start = Time.now
input = File.readlines("input", chomp: true)
  .map{ |bp|
    get_id(
      bp.chars.map{ |c| ['F', 'L'].include?(c) ? 0 : 1 }.join
    )
  }
  .sort
puts "Prep: #{Time.now - start}s"

start = Time.now
part1 = input.last
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = ((input.first..input.last).to_a - input).first
puts "Part 2: #{part2} (#{Time.now - start}s)"