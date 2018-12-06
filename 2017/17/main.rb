input = 356

buffer = [0]
pos = 0

2017.times do |i|
  pos = (pos + input) % buffer.size + 1
  buffer.insert(pos, i + 1)
end
puts "Part 1: #{buffer[(buffer.index(2017) + 1) % buffer.size]}"

at_pos_one = nil
50000000.times do |i|
  pos = (pos + input) % (i + 1) + 1
  at_pos_one = i + 1 if pos == 1
end
puts "Part 2: #{at_pos_one}"