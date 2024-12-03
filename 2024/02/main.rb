require_relative '../util/time'

def prep
  File.readlines("input", chomp: true)
    .map{ _1.split.map(&:to_i) }
end

def is_safe?(report)
  diffs = report.each_cons(2).map{ _2 - _1 }
  diffs.all?{ _1 >= 1 && _1 <= 3 } || diffs.all?{ _1 >= -3 && _1 <= -1 }
end

def part1(input)
  input.count{ is_safe?(_1) }
end

def part2(input)
  input.count do |r|
    is_safe?(r) || (0...r.size).any?{ is_safe?( r.values_at(0..._1, _1+1...r.size) ) }
  end
end

input = time("Prep", false){ prep }
time("Part 1"){ part1(input) }
time("Part 2"){ part2(input) }