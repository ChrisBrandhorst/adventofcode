require_relative '../util/time'

def prep
  File.readlines("input", chomp: true)
    .map{ |l|
      k,vs = l.split(": ")
      [k.to_i, vs.split.map(&:to_i)]
    }.to_h
end

class Integer
  def |(b)
    l = Math.log10(b).to_i + 1
    self * 10**l + b
  end
end

def calc(input, ops = [:*, :+])
  opsp = input.values.map(&:size).uniq
    .map{ [_1, ops.repeated_permutation(_1 - 1)] }.to_h

  input.sum do |a,e|
    opsp[e.size].sum do |ops|
      r = e[0]
      (1...e.size).each{ r = r.send(ops[_1-1], e[_1]) }
      r == a ? (break(a)) : 0
    end
  end
end

def part1(input)
  calc(input)
end

def part2(input)
  calc(input, [:*, :+, :|])
end

input = time("Prep", false){ prep }
time("Part 1"){ part1(input) }
time("Part 2"){ part2(input) }