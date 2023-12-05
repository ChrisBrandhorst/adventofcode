class Range
  def &(other)
    return nil if self.max < other.min or other.max < self.min
    [self.min, other.min].max..[self.max, other.max].min
  end
end


start = Time.now
input = File.readlines("input", chomp: true)

seeds = input.shift.split.drop(1).map(&:to_i)
maps = []
input.each do |l|
  if l == ""
    maps << []
  elsif l[0] =~ /\d/
    ds, ss, l = l.split.map(&:to_i)
    maps.last << [(ss...ss+l),ds-ss]
  end
end
puts "Prep: #{Time.now - start}s"


start = Time.now
locs = seeds.map do |s|
  maps.each do |m|
    m.each do |sr, diff|
      if sr.include?(s)
        s += diff
        break
      end
    end
  end
  s
end
part1 = locs.min
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
locs = seeds.each_slice(2).map{ (_1..._1+_2) }.map do |sr|
  ranges = [sr]
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
part2 = locs.min
puts "Part 2: #{part2} (#{Time.now - start}s)"