start = Time.now
input = File.read("input")
CONFUSING = "iol".chars.map(&:ord)
puts "Prep: #{Time.now - start}s"


def has_straight?(pass)
  pass.each_cons(3).any?{ _3 == _2 + 1 && _3 == _1 + 2 }
end

def has_pairs?(pass)
  pairs = 0
  i = 0
  while i < pairs.size - 1
    if pass[i] == pass[i + 1]
      pairs += 1
      i += 1
      break if pairs == 2
    end
    i += 1
  end
  pairs == 2
end

def increment(pass)
  pass[-1] += 1
  (1..pass.size).each do |i|
    pass[-i] += 1 while CONFUSING.include?(pass[-i])
    if pass[-i] == "z".ord + 1
      pass[-i] = "a".ord
      pass[-i-1] += 1
    else
      break
    end
  end
  pass
end

def next_pass(pass, skip = false)
  pass = pass.chars.map(&:ord)
  pass = increment(pass) if skip
  pass = increment(pass) until has_straight?(pass) && has_pairs?(pass)
  pass.map(&:chr).join
end

start = Time.now
part1 = next_pass(input)
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = next_pass(part1, true)
puts "Part 2: #{part2} (#{Time.now - start}s)"