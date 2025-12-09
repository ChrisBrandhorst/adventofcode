require_relative '../util/time'
require 'set'

def prep
  ranges, available = File.read("input", chomp: true)
    .split("\n\n")
    .map(&:split)
  [
    ranges.map{ _1.split("-").map(&:to_i) },
    available.map(&:to_i)
  ]
end

def part1(ranges, available)
  available.count{ |a| ranges.any?{ |x,y| (x..y).include?(a) } }
end

def combine(a_begin, a_end, b_begin, b_end)
  [[a_begin, b_begin].min, [a_end, b_end].max] if b_begin <= a_end && a_begin <= b_end
end

def part2(ranges)
  combined = []
  remaining = ranges.sort{ |a,b| a <=> b }

  until remaining.empty?
    r = remaining.shift
    new_remaining = []

    until remaining.empty?
      r2 = remaining.shift
      if cr = combine(*r, *r2)
        r = cr
      else
        new_remaining << r2
      end
    end

    remaining = new_remaining
    combined << r
  end

  combined.sum{ _2 - _1 + 1 }
end

ranges, available = time("Prep", false){ prep }
time("Part 1"){ part1(ranges, available) }
time("Part 2"){ part2(ranges) }