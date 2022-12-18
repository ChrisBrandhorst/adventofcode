require 'set'

start = Time.now
input = File.readlines("input", chomp: true)
  .inject(Set.new){ |s,c| s << c.split(",").map(&:to_i); s }

@xr = Range.new(*input.map{_1[0]}.minmax)
@yr = Range.new(*input.map{_1[1]}.minmax)
@zr = Range.new(*input.map{_1[2]}.minmax)

puts "Prep: #{Time.now - start}s"


def neighbours(c)
  [
    [c[0]-1, c[1], c[2]], [c[0]+1, c[1], c[2]],
    [c[0], c[1]-1, c[2]], [c[0], c[1]+1, c[2]],
    [c[0], c[1], c[2]-1], [c[0], c[1], c[2]+1]
  ]
end

def in_bounds?(c)
  @xr.include?(c[0]) && @yr.include?(c[1]) && @zr.include?(c[2])
end


start = Time.now
part1 = input.sum{ |c| neighbours(c).count{ !input.include?(_1) } }
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now

corner = [@xr.first,@yr.first,@zr.first]
visited = Set.new([corner])
water = Set.new([corner])
edge = Set.new
q = [corner]

until q.empty?
  c = q.shift
  neighbours(c).each do |n|
    next if visited.include?(n) || !in_bounds?(n)
    visited << n

    if input.include?(n)
      edge << n
    else
      water << n
      q << n
    end
  end
end

part2 = edge.sum{ |c| neighbours(c).count{ water.include?(_1) || !in_bounds?(_1) } }
puts "Part 2: #{part2} (#{Time.now - start}s)"