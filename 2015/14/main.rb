start = Time.now
input = File.readlines("input", chomp: true).map(&:split).map do |l|
  {
    speed:    l[3].to_i,
    duration: l[6].to_i,
    rest:     l[13].to_i
  }
end
LIMIT = 2503
puts "Prep: #{Time.now - start}s"


start = Time.now
part1 = input.map do |r|
  block = r[:duration] + r[:rest]
  (LIMIT / block + [1, LIMIT % block / r[:duration]].min) * r[:duration] * r[:speed]
end.max
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
distances = [0] * input.size
scores = [0] * input.size
(1..LIMIT).each do |t|
  input.each_with_index do |r,i|
    rem = t % (r[:duration] + r[:rest])
    distances[i] += r[:speed] if rem <= r[:duration] && rem > 0
  end
  max = distances.max
  distances.each.with_index{ scores[_2] += 1 if _1 == max }
end
part2 = scores.max
puts "Part 2: #{part2} (#{Time.now - start}s)"