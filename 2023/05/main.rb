start = Time.now
input = File.readlines("input", chomp: true)

seeds = input.shift.split.drop(1).map(&:to_i)
maps = []
input.each do |l|
  if l == ""
    maps << [] 
  elsif l[0] =~ /\d/
    maps.last << l.split.map(&:to_i)
  end
end
puts "Prep: #{Time.now - start}s"


def get_loc(seed, maps)
  maps.each do |m|
    m.each do |dst_start, src_start, len|
      if seed >= src_start && seed < src_start + len
        seed += dst_start - src_start
        break
      end
    end
  end
  seed
end


start = Time.now
part1 = seeds.map{ get_loc(_1, maps) }.min
puts "Part 1: #{part1} (#{Time.now - start}s)"




class Range
  def overlap?(other)
    return !(self.max < other.begin or other.max < self.begin)
  end
  def intersection(other)
    return nil if !self.overlap?(other)
    [self.begin, other.begin].max..[self.max, other.max].min
  end
  alias_method :&, :intersection
  def lowersection(other)
    return nil if !self.overlap?(other)
    return nil if self.begin >= other.begin
    self.begin..(other.begin-1)
  end
  def uppersection(other)
    return nil if !self.overlap?(other)
    return nil if self.max <= other.max
    (other.max+1)..self.max
  end
end


def get_loc_range(seed_range, maps)

  ranges = [seed_range]
  maps.each do |m|
    
    new_ranges = []
    ranges.each do |r|

      m.each do |dst_start, src_start, len|
        map_r = (src_start..src_start+len-1)
        overlap = r & map_r
        if overlap
          diff = dst_start - src_start
          diff_range = (overlap.min + diff)..(overlap.max + diff)
          new_ranges << r.lowersection(map_r)
          new_ranges << diff_range
          new_ranges << r.uppersection(map_r)
          break
        end
      end

    end
    new_ranges.compact!
    ranges = new_ranges if new_ranges.any?
  end
  ranges.map(&:begin).min
end

seed_ranges = seeds.each_slice(2).map{ (_1.._1+_2-1) }

start = Time.now
part2 = seed_ranges.map{ get_loc_range(_1, maps) }.min
puts "Part 2: #{part2} (#{Time.now - start}s)"