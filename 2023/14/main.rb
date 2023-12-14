require '../util/grid'


class Platform < Grid

  attr_accessor :north_load_hist

  def initialize(rows)
    super(rows)
    @tilt_dirs = [0,1],[1,0],[0,-1],[-1,0]
    @north_load_hist = []
  end

  def north_load
    self.inject(0){ |l,(x,y),v| l + (v == "O" ? self.row_count - y : 0) }
  end

  def tilt!(dir = [0,1])
    dx, dy = dir
    last_rock = {}

    nload = 0
    self.each do |(x,y),_|
      x = self.col_count - x - 1 if dx == -1
      y = self.row_count - y - 1 if dy == -1
      v = self[x,y]
      next if v == "."

      lr_i = dx == 0 ? x : y
      lr = last_rock[lr_i] || (dx + dy < 0 ? self.row_count : -1)

      new_x = dx == 0 ? x : lr + dx
      new_y = dy == 0 ? y : lr + dy

      if v == "O"
        self[x,y] = "."
        self[new_x,new_y] = "O"
        last_rock[lr_i] = lr + dx + dy
        nload += self.row_count - new_y
      elsif v == "#"
        last_rock[lr_i] = dx == 0 ? y : x
      end
    end

    nload
  end

  def tilt_cycle!
    nload = @tilt_dirs.map{ self.tilt!(_1) }.last
    @north_load_hist << nload
    nload
  end

end

start = Time.now
input = File.readlines("input", chomp: true).map(&:chars)
puts "Prep: #{Time.now - start}s"


start = Time.now
part1 = Platform.new(input).tilt!
puts "Part 1: #{part1} (#{Time.now - start}s)"


def find_pattern(arr)
  (2..arr.size).to_a.reverse.each do |pl|
    (0..arr.size-pl).each do |i|
      occs = [i]
      pat = arr[i,pl]
      (i+1..arr.size-pl).each do |j|
        occs << j if arr[j,pl] == pat
        return [arr[occs.first,occs.last-occs.first], occs.first] if occs.size == 2
      end
    end
  end
end


start = Time.now
platform = Platform.new(input)
until platform.north_load_hist.tally.values.max == 6
  nload = platform.tilt_cycle!
end
pattern, pattern_start = find_pattern(platform.north_load_hist)
part2 = pattern[ (1000000000 - pattern_start) % pattern.size - 1 ]
puts "Part 2: #{part2} (#{Time.now - start}s)"