require_relative '../util/time'

def prep
  corners = File.readlines("input", chomp: true)
    .map{ _1.split(",").map(&:to_i) }
  corners + [corners.first]
end

def part1(input)
  input.combination(2).map{ |a,b| square_surface(a,b) }.max
end

def square_surface(a, b)
  ((a[0]-b[0]).abs+1) * ((a[1]-b[1]).abs+1)
end

def line_outside_of_rect?(la, lb, sa, sb)
  s_min_x = sa[0] < sb[0] ? sa[0] : sb[0]
  s_max_x = sa[0] < sb[0] ? sb[0] : sa[0]
  s_min_y = sa[1] < sb[1] ? sa[1] : sb[1]
  s_max_y = sa[1] < sb[1] ? sb[1] : sa[1]

  la[0] <= s_min_x && lb[0] <= s_min_x ||
  la[0] >= s_max_x && lb[0] >= s_max_x ||
  la[1] <= s_min_y && lb[1] <= s_min_y ||
  la[1] >= s_max_y && lb[1] >= s_max_y
end

def part2(input)
  lines = input.each_cons(2).to_a
  input.combination(2).filter_map do |sa,sb|
    square_surface(sa, sb) if lines.all?{ |la,lb| line_outside_of_rect?(la, lb, sa, sb) }
  end.max
end

input = time("Prep", false){ prep }
time("Part 1"){ part1(input) }
time("Part 2"){ part2(input) }