data = File.readlines("input").map(&:to_i)
freq = data.sum

puts "Part 1: #{freq}"

cur_freq = 0
double_freq = 0
all_freqs = []
loop do
  run_freqs = data.inject([]){ |f,i| f << cur_freq += i }
  break if double_freq = (run_freqs & all_freqs).first
  all_freqs += run_freqs
end
puts "Part 2: #{double_freq}"

# Even faster using cycle and Set
require 'set'
cur_freq = 0
all_freqs = Set.new
data.cycle do |i|
  cur_freq  += i
  break if all_freqs.include?(cur_freq)
  all_freqs << cur_freq
end
puts "Part 2: #{cur_freq}"