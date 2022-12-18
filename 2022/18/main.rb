require 'set'

start = Time.now
input = File.readlines("input", chomp: true)
  .inject(Set.new){ |s,c| s << c.split(",").map(&:to_i); s }

xs, ys, zs = input.map{ _1[0] }, input.map{ _1[1] }, input.map{ _1[2] }
min_x, max_x = xs.min, xs.max
min_y, max_y = ys.min, ys.max
min_z, max_z = zs.min, zs.max

puts "Prep: #{Time.now - start}s"


def surface(droplet)
  droplet.sum{ |c| neighbours(c).count{ !droplet.include?(_1) } }
end

def neighbours(c)
  [
    [c[0]-1, c[1], c[2]], [c[0]+1, c[1], c[2]],
    [c[0], c[1]-1, c[2]], [c[0], c[1]+1, c[2]],
    [c[0], c[1], c[2]-1], [c[0], c[1], c[2]+1]
  ]
end


start = Time.now
part1 = surface(input)
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now

root = [min_x,min_y,min_z]
visited = Set.new(root)
water = Set.new(root)
q = [root]

until q.empty?
  c = q.shift
  neighbours(c).each do |n|
    next if visited.include?(n) || n[0] < min_x || n[0] > max_x || n[1] < min_y || n[1] > max_y || n[2] < min_z || n[2] > max_z
    visited << n
    
    unless input.include?(n)
      water << n
      q << n
    end
  end
end

solid_droplet = Set.new
(min_z..max_z).each do |z|
  (min_y..max_y).each do |y|
    (min_x..max_x).each do |x|
      c = [x,y,z]
      next if water.include?(c)
      solid_droplet << c
    end
  end
end

part2 = surface(solid_droplet)
puts "Part 2: #{part2} (#{Time.now - start}s)"