require_relative '../util/time'

def prep
  lines = File.readlines("input", chomp: true)
    .map{ _1 + " " }
end

def part1(input)
  lines = input.map{ _1.split(" ") }
  lines.last.map(&:to_sym)
    .zip( lines[0...-1].transpose.map{ _1.map(&:to_i) } )
    .sum{ |op, nums| nums.inject(&op) }
end

def part2(input)
  ops = input.pop.split(/(?=[^\s])/)
  lengths = ops.map(&:size)
  ops.map!{ _1.strip.to_sym}

  s = 0
  total = 0
  lengths.each_with_index do |l,i|
    total += input
      .map{ _1[s,l-1].chars }
      .transpose
      .map{ _1.join.to_i }
      .inject(&ops[i])
    s += l
  end

  total
end

input = time("Prep", false){ prep }
time("Part 1"){ part1(input) }
time("Part 2"){ part2(input) }