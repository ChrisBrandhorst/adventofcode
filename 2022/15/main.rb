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

  combined_ranges, possible_x = [], nil

  base = x_ranges.shift
  x_ranges.each do |xr|
    if !base.overlaps?(xr)
      combined_ranges << base
      possible_x = base.last + 1
      base = xr
    else
      base = base.combine(xr)
    end
  end
  combined_ranges << base

  [combined_ranges, possible_x]
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
sensed, _ = sensed_ranges(sensors_max, TARGET_Y)
part1 = sensed.sum(&:size) - (sensors_max.values + beacons.to_a).count{ _2 == TARGET_Y }
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = nil
(0..MAX_Y).detect do |y|
  _, x = sensed_ranges(sensors_max, y)
  x.nil? ? false : part2 = x * 4000000 + y
end
puts "Part 2: #{part2} (#{Time.now - start}s)"