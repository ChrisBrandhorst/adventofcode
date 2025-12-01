require_relative '../util/time'

def prep
  File.readlines("input", chomp: true)
    .map{ |l| [l[0], l[1..-1].to_i] }
end

def part1(input)
  pos = 50
  input.sum do |d,s|
    pos = (pos + (d == "L" ? -s : s)) % 100
    pos == 0 ? 1 : 0
  end
end

def part2(input)
  pos, pass = 50, 0

  input.each do |d,s|
    a = s * (d == "L" ? -1 : 1)
    pass += (a < 0 ? -pos % 100 - a : pos + a) / 100
    pos = (pos + a) % 100
  end

  pass
end

input = time("Prep", false){ prep }
time("Part 1"){ part1(input) }
time("Part 2"){ part2(input) }