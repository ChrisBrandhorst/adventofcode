require 'set'

class Range
  def overlaps?(other)
    cover?(other.first) || other.cover?(self.first)
  end
  def combine(other)
    ([self.first,other.first].min..[self.last,other.last].max)
  end
end

def sensed_ranges(sensor_ranges, y)
  x_ranges = []
  sensor_ranges.each do |(sx,sy),d|
    r = d - (sy - y).abs
    x_ranges << (sx-r..sx+r) if r > 0
  end
  x_ranges.sort_by!(&:first)

  base = x_ranges[0]
  x_ranges[1..-1].inject([]) do |cr,xr|
    if !base.overlaps?(xr)
      cr << base
      base = xr
    else
      base = base.combine(xr)
    end
    cr
  end << base
end


start = Time.now
input = File.readlines("input", chomp: true)
  .map{ _1.scan(/[\d-]+/).map(&:to_i) }

sensors_max = {}
beacons = Set.new
input.each do |sx,sy,bx,by|
  sensors_max[[sx,sy]] = (bx-sx).abs + (by-sy).abs
  beacons << [bx,by]
end

TARGET_Y = 2000000
MAX_Y = 4000000

puts "Prep: #{Time.now - start}s"


start = Time.now
part1 = sensed_ranges(sensors_max, TARGET_Y).sum(&:size) - (sensors_max.values + beacons.to_a).count{ _2 == TARGET_Y }
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = nil
(0..MAX_Y).detect do |y|
  sensed = sensed_ranges(sensors_max, y)
  sensed.size == 1 ? false : part2 = (sensed.first.last + 1) * 4000000 + y
end
puts "Part 2: #{part2} (#{Time.now - start}s)"