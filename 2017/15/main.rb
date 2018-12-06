def generator_a(val)
  val * 16807 % 2147483647
end
def generator_b(val)
  val * 48271 % 2147483647
end
def generator_a_2(a)
  loop do
    a = generator_a(a)
    return a if a % 4 == 0
  end
end
def generator_b_2(b)
  loop do
    b = generator_b(b)
    return b if b % 8 == 0
  end
end

def sample(samples, a, b, part2 = false)
  equal_count = 0
  samples.times do
    a = part2 ? generator_a_2(a) : generator_a(a)
    b = part2 ? generator_b_2(b) : generator_b(b)
    equal_count += 1 if (a & 2**16-1) == (b & 2**16-1)
  end
  equal_count
end

part1 = sample(40000000, 512, 191)
puts "Part 1: #{part1}"

part2 = sample(5000000, 512, 191, true)
puts "Part 2: #{part2}"