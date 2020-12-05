start = Time.now
input = File.readlines("input").map(&:to_i)
puts "Prep: #{Time.now - start}s"

start = Time.now
part1 = nil
input.each do |i|
  input.each do |j|
    part1 = i * j if i + j == 2020
  end
  break unless part1.nil?
end
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = input.combination(3).find{ |a,b,c| a + b + c == 2020 }.inject(:*)
puts "Part 2: #{part2} (#{Time.now - start}s)"