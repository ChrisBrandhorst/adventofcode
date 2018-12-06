class Coords
  attr_reader :x, :y, :count

  def initialize(x,y)
    @x = x
    @y = y
    @infinite = false
    @count = 0
  end

  def distance_to(x, y)
    (@x - x).abs + (@y - y).abs
  end

  def infinite!
    @infinite = true
  end

  def infinite?
    @infinite
  end

  def count!
    @count += 1
  end

end

data = File.readlines("input").map{ |c| Coords.new( *c.split(", ").map(&:to_i) ) }

x_axis = data.minmax{ |a,b| a.x <=> b.x }.map(&:x)
y_axis = data.minmax{ |a,b| a.y <=> b.y }.map(&:y)

part2 = 0
(y_axis.first..y_axis.last).each do |y|
  (x_axis.first..x_axis.last).each do |x|

    distances = data.map{ |c| c.distance_to(x,y) }

    # Part 1
    mins = distances.group_by(&:itself).min
    if mins.last.size == 1
      coords = data[distances.index(mins.first)]
      coords.count!
      coords.infinite! if x_axis.include?(x) || y_axis.include?(y)
    end

    # Part 2
    part2 += 1 if distances.sum < 10000
  end
end

part1 = data.reject{ |c| c.infinite? }.max{ |a,b| a.count <=> b.count }.count
puts "Part 1: #{part1}"
puts "Part 2: #{part2}"