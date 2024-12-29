start = Time.now
input = File.readlines("input", chomp: true).map do
  parts = _1[0..-2].split.values_at(0, 2, 3, 10)
  [[parts[0],parts[3]], parts[2].to_i * (parts[1] == "lose" ? -1 : 1)]
end.to_h
puts "Prep: #{Time.now - start}s"


def score(input, l, m, r)
  [input[[m,l]], input[[m,r]]]
end

start = Time.now
scores = input.keys.map{ _1.first }.uniq.permutation.map do |order|
  order.each_with_index.flat_map do |m,i|
    score(input, order[i-1], m, order[(i+1) % order.size])
  end
end
optimal = scores.map(&:flatten).max{ _1.sum <=> _2.sum }
part1 = optimal.sum
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = part1 - optimal.unshift(optimal.pop).each_slice(2).map(&:sum).min
puts "Part 2: #{part2} (#{Time.now - start}s)"