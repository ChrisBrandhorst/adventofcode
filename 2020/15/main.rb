start = Time.now
input = File.read("input").split(',').map(&:to_i)
puts "Prep:   #{Time.now - start}s"

def run(input, target)
  seq = input.map.with_index{ |a,i| [a,[i]] }.to_h
  last = input.last

  input.size.step do |size|
    break if size == target
    turns = seq[last]
    last = turns.size == 1 ? 0 : size - turns[-2] - 1
    (seq[last] ||= []) << size
  end

  last
end

start1 = Time.now
part1 = run(input, 2020)
puts "Part 1: #{part1} (#{Time.now - start1}s)"

start2 = Time.now
part2 = run(input, 30000000)
puts "Part 2: #{part2} (#{Time.now - start2}s)"

puts "Total:  #{Time.now - start}s"