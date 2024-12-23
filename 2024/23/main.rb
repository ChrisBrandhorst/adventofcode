require_relative '../util/time'
require 'set'

def prep
  conns = Hash.new{ _1[_2] = [] }

  File.readlines("input", chomp: true)
    .each{
      a, b = _1.split("-")
      conns[a] << b
      conns[b] << a
    }
  conns
end

def part1(conns)
  res = Set.new

  conns.each do |a,bs|
    bs.each do |b|
      conns[b].each do |c|
        if conns[c].include?(a)
          s = [a, b, c]
          res << Set.new(s) if s.any?{ _1[0] == "t" }
        end
      end
    end
  end

  res.size
end

def part2(conns)
  conns.detect do |f,tos|
    ftos = tos+[f]
    lan = tos.map{ ftos & conns[_1]+[_1] }.tally.select{ |_,c| c == tos.size - 1 }.keys.first
    return lan.sort.join(",") if lan
  end
end

conns = time("Prep", false){ prep }
time("Part 1"){ part1(conns) }
time("Part 2"){ part2(conns) }