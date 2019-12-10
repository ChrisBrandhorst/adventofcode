input = File.readlines("input").map(&:strip).map(&:chars)

class Asteroid

  attr_reader :x, :y, :in_sight

  def initialize(x,y)
    @x = x
    @y = y
    @in_sight = []
    @vaporized = false
  end

  def has_in_sight!(other)
    @in_sight << other
  end

  def inspect
    "(#{x},#{y})"
  end

  def vaporize!
    @vaporized = true
  end

  def vaporized?
    @vaporized
  end

  def d(other)
    {
      x: (x - other.x),
      y: (y - other.y)
    }
  end

end

def get_in_sight(asteroids, input, a)
  res = []
  x_range = (0..input.first.size - 1)
  y_range = (0..input.size - 1)

  asteroids.each_with_index do |b,j|
    next if a == b

    # Same row, nothing in between
    if a.y == b.y
      res << b if (asteroids.index(a)-j).abs == 1
      next
    end
    
    # Get delta vector
    d = a.d(b)
    
    # Immediate non-diagonal neighbours
    if d[:x].abs + d[:y].abs == 1
      res << b
      next
    end

    # Same column
    if d[:x].abs == 0
      s = a.y - b.y < 0 ? -1 : 1
      sy = b.y + s
      in_sight = true
      while in_sight && sy != a.y
        in_sight = false if input[sy][a.x] != '.'
        sy += s
      end
      res << b if in_sight
      next
    end

    # Calculate smallest integer step
    lcm = d[:x].lcm(d[:y])
    if d[:x].abs - d[:y].abs > 0
      ay = lcm / d[:x].abs
      ax = d[:x].abs / (d[:y].abs / ay)
    else
      ax = lcm / d[:y].abs
      ay = d[:y].abs / (d[:x].abs / ax)
    end
    ax = -ax if d[:x] < 0
    ay = -ay if d[:y] < 0

    # Look outward using the integer steps
    if ax.round == ax || ay.round == ay
      sx = b.x + ax
      sy = b.y + ay
      in_sight = true
      while in_sight && sx != a.x && x_range.member?(sx) && y_range.member?(sy)
        in_sight = false if input[sy][sx] != '.'
        sx += ax
        sy += ay
      end
      res << b if in_sight
    end

  end

  res
end

start = Time.now
asteroids = []
input.each_with_index do |r,y|
  r.each_with_index do |pos,x|
    next if pos == '.'
    asteroids << Asteroid.new(x,y)
  end
end
puts "Building: #{Time.now-start}s"

start = Time.now
asteroids.each do |a|
  in_sight = get_in_sight(asteroids, input, a)
  in_sight.each{ |b| a.has_in_sight!(b) }
end
target = asteroids.max{ |a,b| a.in_sight.size <=> b.in_sight.size }
part1 = target.in_sight.size
puts "Part 1: #{part1} (#{Time.now-start}s)"

start = Time.now
vaporized = []
while asteroids.select{ |a| !a.vaporized? }.size > 1 && vaporized.size < 200
  targets = []

  get_in_sight(asteroids, input, target).each do |b|
    d = target.d(b)
    
    ang = Math.atan2(-d[:x], d[:y])
    ang = 2 * Math::PI + ang if d[:x] > 0

    targets << {
      :ang => ang,
      :ast => b
    }
  end

  targets.sort_by{ |t| t[:ang] }.each do |t|
    t[:ast].vaporize!
    vaporized << t[:ast]
  end
end
th = vaporized[199]
part2 = th.x * 100 + th.y
puts "Part 2: #{part2} (#{Time.now-start}s)"