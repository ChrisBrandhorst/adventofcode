INPUT_FORMAT = /position=<\s*?([\d-]+),\s*?([\d-]+)> velocity=<\s*?([\d-]+),\s*?([\d-]+)>/

class Light

  attr_reader :x, :y

  def initialize(x, y, dx, dy)
    @x = x
    @y = y
    @dx = dx
    @dy = dy
  end

  def move!
    @x += @dx
    @y += @dy
  end

  def back!
    @x -= @dx
    @y -= @dy
  end

end

class Sky

  attr_reader :lights, :time

  def initialize(lights)
    @lights = lights
    @time = 0
  end

  def move!
    @lights.each(&:move!)
    @time += 1
  end

  def back!
    @lights.each(&:back!)
    @time -= 1
  end

  def y_axis
    @lights.minmax{ |a,b| a.y <=> b.y }.map(&:y)
  end

  def x_axis
    @lights.minmax{ |a,b| a.x <=> b.x }.map(&:x)
  end

  def area
    y_axis = self.y_axis
    x_axis = self.x_axis
    (y_axis.last - y_axis.first) * (x_axis.last - x_axis.first)
  end

  def to_s
    y_axis = self.y_axis
    x_axis = self.x_axis

    arr = []
    lights.each do |l|
      arr[l.y - y_axis.first] ||= ['.'] * (x_axis.last - x_axis.first)
      arr[l.y - y_axis.first][l.x - x_axis.first] = '#'
    end

    arr.map{ |y| y.join('') }.join("\n")
  end

end

lights = File.readlines("input").map{ |l| l.match(INPUT_FORMAT){ |m| Light.new(*m.captures.map(&:to_i)) } }

prev_area = -1
sky = Sky.new(lights)
loop do

  area = sky.area

  if prev_area > 0 && area > prev_area
    sky.back!
    puts "Part 1:"
    puts sky.to_s
    puts "Part 2: #{sky.time}"
    break
  else
    prev_area = area
    sky.move!
  end

end