input = File.read("input").split("\t").map(&:to_i)

history = []
current = input.clone
cycles = 0
answer1, answer2 = 0
while true
  cycles += 1
  i = current.index(current.max)
  blocks = current[i]
  current[i] = 0
  (1..blocks).each{ |j| current[(i + j) % current.size] += 1 }
  if history.include? current
    if answer1 == 0
      answer1 = cycles
      history.clear
    else
      answer2 = cycles - answer1
      break
    end
  end
  history << current.clone
end
puts "Part 1: #{answer1}"
puts "Part 1: #{answer2}"