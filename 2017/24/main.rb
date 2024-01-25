require 'set'
input = File.readlines("input").map{ _1.split("/").map(&:to_i) }

components = Set.new(input)

starts = input.select{ _1.first == 0 || _1.last == 0 }
components -= starts

def bridges(bridge, port, remaining)
  bridges = [bridge]
  remaining.each do |r|
    first_match, last_match = r[0] == port, r[1] == port
    bridges += bridges(bridge + [r], first_match ? r[1] : r[0], remaining - [r]) if first_match || last_match
  end
  bridges
end

bridges = starts.map{ bridges([_1], _1.sum, components) }.flatten(1).map{ [_1.flatten.sum, _1.size] }

part1 = bridges.map{ _1.first }.max
puts "Part 1: #{part1}"

max_length = bridges.map{ _1.last }.max
part2 = bridges.filter_map{ _1.first if _1.last == max_length }.max
puts "Part 2: #{part2}"