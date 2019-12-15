require '../intcode/intcode'
require './astar'

input = File.read("input").split(",").map(&:to_i)

class RepairDroid

  DIR_NORTH = 1
  DIR_SOUTH = 2
  DIR_WEST = 3
  DIR_EAST = 4

  STATUS_WALL = 0
  STATUS_MOVED = 1
  STATUS_OXYGEN = 2

  def initialize(input, section)
    @intcode = Intcode.new(input)
    @x = 40
    @y = 40
    @ox_x = nil
    @ox_y = nil
    @section = section
  end

  def render
    print "\e[2J\e[f"
    puts @section.render
  end

  def move!(dir)
    case dir
    when DIR_NORTH; @y -= 1
    when DIR_SOUTH; @y += 1
    when DIR_WEST; @x -= 1
    when DIR_EAST; @x += 1
    end
  end

  def explore!(vis = false)
    discovered = nil
    discover_dir = nil
    cur_path = []

    @intcode.run do |op,out|
      case op
      when :in
        adj = @section.adjecent(@section[@x,@y])
        discovered = adj.find(&:unknown?)

        if discovered.nil?
          break if cur_path.empty?
          prev_dir = cur_path.pop
          discover_dir = prev_dir.odd? ? prev_dir + 1 : prev_dir - 1
        else
          discover_dir = adj.index(discovered) + 1
          cur_path << discover_dir
        end
      when :out
        case out
        when STATUS_WALL
          discovered.wall! unless discovered.nil?
          cur_path.pop
        when STATUS_MOVED
          discovered.empty! unless discovered.nil?
          move!(discover_dir)
        when STATUS_OXYGEN
          yield(:part1, cur_path.size) if block_given?
          discovered.oxygen! unless discovered.nil?
          move!(discover_dir)
          @ox_x = @x
          @ox_y = @y
        end
        if vis
          render
          sleep(0.001)
        end
      end
      discover_dir
    end

  end

  def oxygenize!(vis = false)
    fronts = [@section[@ox_x, @ox_y]]

    m = 0
    while fronts.any?
      fronts = fronts.map{ |f| @section.adjecent(f).select{ |i| i.empty? } }.flatten.each(&:oxygen!)
      m += 1
      if vis
        render
        sleep(0.02)
      end
    end 

    m - 1
  end

end

class ShipSection

  def initialize
    @items = []
  end

  def [](x, y)
    if y == -1
      @items.unshift(nil)
      y = 0
    end
    if x == -1
      @items.each{ |r| r.unshift(nil) unless r.nil? }
      x = 0
    end

    @items[y] ||= []
    @items[y][x] = ShipSectionItem.new(x,y) if @items[y][x].nil?
    @items[y][x]
  end

  def []=(x,y,item)
    @items[y] ||= []
    @items[y][x] = item
  end

  def adjecent(item)
    [
      self[item.x,item.y-1],
      self[item.x,item.y+1],
      self[item.x-1,item.y],
      self[item.x+1,item.y]
    ]
  end

  def render
    @items.compact.map{ |r| r.nil? ? "" : r.map{ |i| i.nil? ? " " : i.render }.join("") }.join("\n")
  end

end

class ShipSectionItem

  UNKNOWN = 0
  EMPTY = 1
  WALL = 2
  OXYGEN = 3

  attr_reader :x, :y, :type

  def initialize(x,y, type = UNKNOWN)
    @x = x
    @y = y
    @type = type
  end

  def unknown?; @type == UNKNOWN; end
  def empty?; @type == EMPTY; end

  def wall!; @type = WALL; end
  def empty!; @type = EMPTY; end
  def oxygen!; @type = OXYGEN; end

  def render
    case @type
    when UNKNOWN; " "
    when EMPTY; "."
    when WALL; "#"
    when OXYGEN; "O"
    end
  end

end

start = Time.now
section = ShipSection.new
repair_droid = RepairDroid.new(input, section)
repair_droid.explore! do |part, val|
  puts "Part 1: #{val} (#{Time.now - start}s)" if part == :part1
end
puts "Exploring: #{Time.now - start}s"

start = Time.now
part2 = repair_droid.oxygenize!
puts "Part 2: #{part2} (#{Time.now - start}s)"