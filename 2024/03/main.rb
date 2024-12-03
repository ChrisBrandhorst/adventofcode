require_relative '../util/time'

def prep
  File.read("input", chomp: true)
end

def part1(input)
  input.scan(/mul\((\d+),(\d+)\)/).sum{ _1[0].to_i * _1[1].to_i }
end

def part2(input)
  enabled = true
  input.scan(/(mul\((\d+),(\d+)\)|(do(n't)?)\(\))/).sum do |m|
    enabled = m[4].nil? if !m[3].nil?
    enabled ? m[1].to_i * m[2].to_i : 0
  end
end

input = time("Prep", false){ prep }
time("Part 1"){ part1(input) }
time("Part 2"){ part2(input) }