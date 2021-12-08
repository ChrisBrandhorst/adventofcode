start = Time.now
input = File.readlines("input", chomp: true).map{ |l| l.split(' | ').map{ |l| l.split(' ').map{ |d| d.chars.sort } } }

digits = {
  0 => %w(a b c e f g),
  1 => %w(c f),
  2 => %w(a c d e g),
  3 => %w(a c d f g),
  4 => %w(b c d f),
  5 => %w(a b d f g),
  6 => %w(a b d e f g),
  7 => %w(a c f),
  8 => %w(a b c d e f g),
  9 => %w(a b c d f g)
}

unique_sizes = digits.values.map(&:size).tally.select{ |k,v| v == 1 }.keys
puts "Prep: #{Time.now - start}s"


start = Time.now
part1 = input.sum{ |i| i.last.count{ |v| unique_sizes.include?(v.size) } }
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now

unique_size_digits = digits.select{ |k,v| unique_sizes.include?(v.size) }
unique_size_to_digit = unique_size_digits.inject({}) { |u,(d,s)| u[s.size] = d; u }
overlap_with_unique_digits = digits.map{ |d,s| unique_size_digits.map{ |ud,us| (s & us).size } }

part2 = input.sum do |i|

  these_segments = []

  non_unique_digits = i.first.reject do |v|
    s = unique_size_to_digit[v.size]
    s ? these_segments[s] = v : false
  end

  non_unique_digits.each do |s|
    overlaps = unique_size_digits.map{ |ud,us| (these_segments[ud] & s).size }
    these_segments[ overlap_with_unique_digits.index(overlaps) ] = s
  end

  i.last.map{ |o| these_segments.index(o) }.join.to_i
end

puts "Part 2: #{part2} (#{Time.now - start}s)"