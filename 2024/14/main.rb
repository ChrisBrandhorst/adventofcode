require_relative '../util/time'

def prep
  File.readlines("input", chomp: true)
    .map{ |r| r.scan(/=(\d+),(\d+).*?=(-?\d+),(-?\d+)/).first.map(&:to_i) }
end

SW, SH = 101, 103

def part1(input)
  robots = input.map do |x,y,dx,dy|
    100.times do |s|
      x = (x + dx) % SW
      y = (y + dy) % SH
    end
    [x,y]
  end
  
  qs = [0,0,0,0]
  robots.each do |x,y|
    unless x == SW / 2 || y == SH / 2
      qs[2*x/SW + (2*y/SH) * 2] += 1
    end
  end
  qs.flatten.inject(&:*)
end

def part2(input)
  1.step do |i|
    seen = Set.new
    counter = []
    input.map! do |x,y,dx,dy|
      seen << [x = (x + dx) % SW, y = (y + dy) % SH]
      [x,y,dx,dy]
    end    
    return i if seen.size == input.size
  end
end

def output(rs)
  out = ""
  SH.times do |y|
    SW.times do |x|
      out += (rs.include?([x,y]) ? "#" : ".").to_s
    end
    out += "\n"
  end
  puts out
end

input = time("Prep", false){ prep }
time("Part 1"){ part1(input) }
time("Part 2"){ part2(input) }
time("Output", false){ output(input.map{_1[0..1]}) }