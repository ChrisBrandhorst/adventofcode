start = Time.now
input = File.read("input").split(',').map(&:to_i)
puts "Prep:   #{Time.now - start}s"

start1 = Time.now
spoken = [] | input

until spoken.size == 2020
  last = spoken.last
  count = spoken.count(last)

  if count == 1
    spoken << 0
  else
    spoken[spoken.size-1] = -1
    ri = spoken.rindex(last)
    spoken[spoken.size-1] = last
    nl = (spoken.size) - (ri + 1)
    spoken << nl
  end
end

part1 = spoken.last
puts "Part 1: #{part1} (#{Time.now - start1}s)"

start2 = Time.now

spoken = input.map.with_index{ |a,i| [a,[i]] }.to_h
count = spoken.keys.size
last = input.last

until count == 30000000
  if spoken[last] && spoken[last].size == 1
    (spoken[0] ||= []) << count
    last = 0
  else
    nl = count - spoken[last][-2] + 1
    (spoken[nl] ||= []) << count
    last = nl
  end
  count += 1
  puts count if count % 100000 == 0
end

part2 = last
puts "Part 2: #{part2} (#{Time.now - start2}s)"

puts "Total:  #{Time.now - start}s"