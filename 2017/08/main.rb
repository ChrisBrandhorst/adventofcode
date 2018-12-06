registers = {}
max = 0

input = File.readlines("input").map do |l|
  l =~ /^(\w+) (inc|dec) ([\d-]+) if (\w+) ([\<\>\!=]+ [\d-]+)$/
  eval("registers[:#{$1}] ||= 0")
  eval("registers[:#{$4}] ||= 0")
  eval("registers[:#{$1}] #{$2 == 'inc' ? '+' : '-'}= #{$3} if registers[:#{$4}] #{$5}")
  temp_max = registers.values.max
  max = temp_max if temp_max > max
end

puts "Part 1: #{registers.values.max}"
puts "Part 2: #{max}"