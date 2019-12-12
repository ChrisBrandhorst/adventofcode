require '../intcode/intcode'

input = File.read("input").split(",").map(&:to_i)

class PaintRobot
  BLACK = 0
  WHITE = 1

  LEFT = 0
  RIGHT = 1

  DIR_UP = 0
  DIR_RIGHT = 1
  DIR_DOWN = 2
  DIR_LEFT = 3

  attr_reader :panels

  def initialize(input, start_color = nil, start_x = 0, start_y = 0, start_dir = PaintRobot::DIR_UP)
    @panels = []
    @intcode = Intcode.new(input)
    @x = start_x
    @y = start_y
    @dir = start_dir
    set_panel(start_x, start_y, start_color) unless start_color.nil?
  end

  def set_panel(x, y, color)
    if y == -1
      @panels.unshift(nil)
      y = 0
    end
    if x == -1
      @panels.each{ |r| r.unshift(nil) unless r.nil? }
      x = 0
    end
    @panels[y] ||= []
    @panels[y][x] = color
    [x, y]
  end

  def get_panel(x, y)
    if x < 0 || y < 0 || @panels[y].nil?
      PaintRobot::BLACK
    else
      @panels[y][x] || PaintRobot::BLACK
    end
  end

  def next_step!(turn)
    @dir = @dir + (turn * 2 - 1)
    @dir += 4 if @dir == -1
    @dir -= 4 if @dir == 4

    if @dir % 2 == 0
      @y += @dir - 1
    else
      @x += -(@dir - 2)
    end
  end

  def run!
    i = 0
    @intcode.run do |op,out|
      case i
      when 0
        inp = get_panel(@x, @y)
      when 1
        @x, @y = set_panel(@x, @y, out)
      when 2
        next_step!(out)
      end

      i += 1
      i = 0 if i == 3
      inp
    end

    self
  end

  def render
    puts @panels.compact.map{ |r| r.map{ |p| p.nil? ? " " : (p == 0 ? "." : "#") }.join }.join("\n")
  end

end

start = Time.now
paint_robot = PaintRobot.new(input)
part1 = paint_robot.run!.panels.flatten.compact.size
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
paint_robot = PaintRobot.new(input, PaintRobot::WHITE)
part2 = paint_robot.run!.panels
puts "Part 2: (#{Time.now - start}s)"
puts paint_robot.render