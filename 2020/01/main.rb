start = Time.now
input = File.readlines("input").map(&:to_i)
puts "Prep: #{Time.now - start}s"

def find_entries(input, n, s)
  input.combination(n).find{ |c| c.sum == s }.inject(:*)
end

start = Time.now
part1 = find_entries(input, 2, 2020)
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = find_entries(input, 3, 2020)
puts "Part 2: #{part2} (#{Time.now - start}s)"