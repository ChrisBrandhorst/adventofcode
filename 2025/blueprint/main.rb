require_relative '../util/time'

def prep
  File.readlines("input", chomp: true)
end

def part1(input)
  nil
end

def part2(input)
  nil
end

input = time("Prep", false){ prep }
time("Part 1"){ part1(input) }
time("Part 2"){ part2(input) }