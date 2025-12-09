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

def part2(input)
  lines = input.each_cons(2).to_a
  input.combination(2).filter_map do |a,b|
    min_x = a[0] < b[0] ? a[0] : b[0]
    max_x = a[0] < b[0] ? b[0] : a[0]
    min_y = a[1] < b[1] ? a[1] : b[1]
    max_y = a[1] < b[1] ? b[1] : a[1]
    square_surface(a, b) if lines.all? do |la,lb|
      la[0] <= min_x && lb[0] <= min_x ||
      la[0] >= max_x && lb[0] >= max_x ||
      la[1] <= min_y && lb[1] <= min_y ||
      la[1] >= max_y && lb[1] >= max_y
    end
  end.max
end

input = time("Prep", false){ prep }
time("Part 1"){ part1(input) }
time("Part 2"){ part2(input) }