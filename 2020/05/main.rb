def get_row(bp)
  (0..6).map{ |i| 2 ** (6-i) * bp[i] }.sum
end

def get_col(bp)
  (7..9).map{ |i| 2 ** (9-i) * bp[i] }.sum
end

def get_id(bp)
  get_row(bp) * 8 + get_col(bp)
end

start = Time.now
input = File.readlines("input", chomp: true)
  .map{ |bp|
    get_id(
      bp.chars.map{ |c| ['F', 'L'].include?(c) ? 0 : 1 }
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