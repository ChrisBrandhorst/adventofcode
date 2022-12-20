start = Time.now
input = File.readlines("input", chomp: true).map(&:to_i)
puts "Prep: #{Time.now - start}s"

def calc(input, part2 = false)
  pairs = input.each_with_index.map{ |n,i| [n * (part2 ? 811589153 : 1), i] }
  (part2 ? 10 : 1).times do
    pairs.size.times do |in_idx|
      move_idx = pairs.index{ _1[1] == in_idx }
      new_idx = (move_idx + pairs[move_idx][0]) % (pairs.size - 1)
      pairs.insert(new_idx, pairs.delete_at(move_idx))
    end
  end

  zero_idx = pairs.index{ _1[0] == 0 }
  [1,2,3].map{ pairs[(zero_idx + 1000 * _1) % pairs.size][0] }.sum
end

start = Time.now
part1 = calc(input)
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = calc(input, true)
puts "Part 2: #{part2} (#{Time.now - start}s)"