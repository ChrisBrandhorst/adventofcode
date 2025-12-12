require_relative '../util/time'

def prep
  File.read("input", chomp: true)
    .split("\n\n")
    .pop
    .split("\n")
    .map{ _1.scan(/\d+/).map(&:to_i) }
end

def part1(regions)
  regions.select{ |r| r[0] * r[1] >= 9 * r[2..-1].sum }.size
end

input = time("Prep", false){ prep }
time("Part 1"){ part1(input) }