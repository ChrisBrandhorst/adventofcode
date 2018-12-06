phrases = File.readlines("input")

valid = phrases.select do |phrase|
  words = phrase.split(' ')
  words.size == words.uniq.size
end.size
puts "Part 1: #{valid}"

valid = phrases.select do |phrase|
  words = phrase.split(' ').map{ |w| w.chars.sort.join }
  words.size == words.uniq.size
end.size
puts "Part 2: #{valid}"