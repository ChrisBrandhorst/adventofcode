digits = File.read("input").chars.map(&:to_i)

sum = 0
digits.each_with_index do |d,i|
  sum += d if d == digits[i - 1]
end
puts "Part 1: #{sum}"

sum2 = 0
digits.each_with_index do |d,i|
  sum2 += d if d == digits[i - digits.size / 2]
end
puts "Part 2: #{sum2}"