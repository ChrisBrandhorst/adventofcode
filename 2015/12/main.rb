require 'json'

start = Time.now
input = File.read("input")
puts "Prep: #{Time.now - start}s"


start = Time.now
part1 = input.scan(/[-\d]+/).map(&:to_i).sum
puts "Part 1: #{part1} (#{Time.now - start}s)"


def part2(obj)
  return 0 if obj.is_a?(Hash) && obj.values.include?("red")
  obj.sum do |v|
    if v.is_a?(Enumerable)
      part2(v)
    elsif v.is_a?(Integer)
      v
    else
      0
    end
  end
end

start = Time.now
part2 = part2(JSON.parse(input))
puts "Part 2: #{part2} (#{Time.now - start}s)"