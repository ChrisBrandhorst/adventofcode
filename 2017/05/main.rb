input = File.readlines("input").map(&:to_i)

jumps = input.clone
pos = 0
steps = 0
while jumps[pos]
  steps += 1
  jump = jumps[pos]
  jumps[pos] += 1
  pos += jump
end
puts "Part 1: #{steps}"

jumps = input.clone
pos = 0
steps = 0
while jumps[pos]
  steps += 1
  jump = jumps[pos]
  jumps[pos] += jump >=3 ? -1 : 1
  pos += jump
end
puts "Part 2: #{steps}"