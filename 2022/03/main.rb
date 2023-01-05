start = Time.now
input = File.readlines("input", chomp: true)
puts "Prep: #{Time.now - start}s"

class String
  def priority
    o = self.ord
    o - (o > 96 ? 96 : 38)
  end
end

start = Time.now
part1 = input.sum{ _1.chars.each_slice(_1.length/2).inject(:&).first.priority }
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = input
  .each_slice(3)
  .sum{ _1.map(&:chars).inject(:&).first.priority }
puts "Part 2: #{part2} (#{Time.now - start}s)"