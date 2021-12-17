require 'set'

MATCHER = /x=([-\d]+)..([-\d]+), y=([-\d]+)..([-\d]+)/
TARGET_X_MIN, TARGET_X_MAX, TARGET_Y_MIN, TARGET_Y_MAX = 0, 1, 2, 3

start = Time.now
input = File.read("input", chomp: true)
target = input.scan(MATCHER).first.map(&:to_i)
puts "Prep: #{Time.now - start}s"


start = Time.now

max_y = 0
velocities = Set.new

(target[TARGET_X_MAX] + 1).downto(2).each do |cur_vx|
  (target[TARGET_Y_MIN]..target[TARGET_X_MAX]).each do |cur_vy|

    x, y, vx, vy = 0, 0, cur_vx, cur_vy
    hit, out_of_range = false, false
    cur_max_y = 0

    until out_of_range || hit
      x += vx
      y += vy
      vx = vx > 0 ? vx - 1 : (vx < 0 ? vx + 1 : 0)
      vy -= 1
      cur_max_y = y if y > cur_max_y

      out_of_range = !(x <= target[TARGET_X_MAX] && y >= target[TARGET_Y_MIN])
      hit = !out_of_range && x >= target[TARGET_X_MIN] && y <= target[TARGET_Y_MAX]
    end

    if hit
      max_y = cur_max_y if cur_max_y > max_y
      velocities << [cur_vx, cur_vy]
    end

  end
end


part1 = max_y
part2 = velocities.count
puts "Part 1: #{part1}"
puts "Part 2: #{part2}"
puts "Part 1&2: (#{Time.now - start}s)"