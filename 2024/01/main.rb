require_relative '../util/time'

def prep
  File.readlines("input", chomp: true)
    .map{ _1.split.map(&:to_i) }
    .transpose
    .map(&:sort)
end

def part1(input)
  input.transpose.sum{ (_2-_1).abs }
end

def part2(input)
  input.first.sum{ _1 * input.last.count(_1) }
end

input = time("Prep", false){ prep }
time("Part 1"){ part1(input) }
time("Part 2"){ part2(input) }