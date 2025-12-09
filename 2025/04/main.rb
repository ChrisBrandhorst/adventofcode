require_relative '../util/time'
require_relative '../util/grid'

def prep
  Grid.new(
    File.readlines("input", chomp: true)
      .map(&:chars),
    true
  )
end

def accessible(input)
  input.select do |(x,y),v|
    v == "@" && input.adj(x,y).count{ _1 == "@" } < 4
  end
end

def part1(input)
  accessible(input).count
end

def part2(input)
  moved = 0
  until (to_move = accessible(input)).empty?
    moved += to_move.each{ input[_1[0]] = "." }.size
  end
  moved
end

input = time("Prep", false){ prep }
time("Part 1"){ part1(input) }
time("Part 2"){ part2(input) }