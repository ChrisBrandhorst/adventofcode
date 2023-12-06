class Range
  def &(other)
    return nil if self.max < other.min or other.max < self.min
    [self.min, other.min].max..[self.max, other.max].min
  end
end


def loc_single(seed, maps)
  maps.inject(seed) do |s,m|
    m.detect{ |sr, diff| s += diff if sr.include?(s) }
    s
  end
end


def loc_range(seed_range, maps)
  ranges = maps.inject([seed_range]) do |rs,m|
    new_rs = rs.inject([]) do |nr,r|
      m.detect do |mr, diff|
        if overlap = r & mr
          diff_range = (overlap.min + diff)..(overlap.max + diff)
          nr << (r.min...mr.min) unless r.min >= mr.min
          nr << diff_range
          nr << (mr.max+1..r.max) unless r.max <= mr.max
          true
        end
      end
      nr
    end
    new_rs.any? ? new_rs : rs
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