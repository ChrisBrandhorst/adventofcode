class Range
  def &(other)
    return nil if self.max < other.min or other.max < self.min
    [self.min, other.min].max..[self.max, other.max].min
  end
end


def loc_single(seed, maps)
  maps.each do |m|
    m.each do |sr, diff|
      if sr.include?(seed)
        seed += diff
        break
      end
    end
  end
  seed
end


def loc_range(seed_range, maps)
  ranges = [seed_range]
  maps.each do |m|
    new_ranges = []
    ranges.each do |r|
      m.each do |mr, diff|
        overlap = r & mr
        if overlap
          diff_range = (overlap.min + diff)..(overlap.max + diff)
          new_ranges << (r.min...mr.min) unless r.min >= mr.min
          new_ranges << diff_range
          new_ranges << (mr.max+1..r.max) unless r.max <= mr.max
          break
        end
      end
    end
    ranges = new_ranges if new_ranges.any?
  end
  ranges.map(&:min).min
end


start = Time.now
input = File.readlines("input", chomp: true)
seeds = input.shift.split.drop(1).map(&:to_i)
maps = input.slice_before("").map do |l|
  l.drop(2).map do |m|
    ds, ss, l = m.split.map(&:to_i)
    [(ss...ss+l), ds-ss]
  end
end
puts "Prep: #{Time.now - start}s"


start = Time.now
part1 = seeds.map{ loc_single(_1, maps) }.min
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = seeds.each_slice(2).map{ (_1..._1+_2) }.map{ loc_range(_1, maps) }.min
puts "Part 2: #{part2} (#{Time.now - start}s)"


start = Time.now
part1b = seeds.map{ (_1.._1) }.map{ loc_range(_1, maps) }.min
puts "Part 1 with 2 logic: #{part1b} (#{Time.now - start}s)"