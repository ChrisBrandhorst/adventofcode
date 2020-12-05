require './astar.rb'

class Maze

  attr_reader :portals

  def initialize(mazearr)
    @portals = []

    @maze = mazearr.each_with_index.map do |row,y|
      row.each_with_index.map do |mazeitem,x|
        case mazeitem
        when '#'
          Wall.new(x,y)
        when '.'
          Void.new(x,y)
        else
          if mazeitem.match(/[A-Z]/)
            PortalCode.new(x,y,mazeitem)
          end
        end
      end
    end

    @maze.each_with_index do |row,y|
      row.each_with_index do |mazeitem,x|
        next unless mazeitem.is_a?(PortalCode)

        new_portal = nil

        if x > 0 && @maze[y][x-1].is_a?(PortalCode) && @maze[y][x+1].is_a?(Void)
          new_portal = Portal.new(x, y, @maze[y][x-1].val + mazeitem.val, @maze[y][x+1], x == 1 || x == @maze[y].size - 2 ? :outer : :inner)
          @maze[y][x+1].portal = new_portal;
          @maze[y][x-1] = nil

        elsif x > 0 && @maze[y][x+1].is_a?(PortalCode) && @maze[y][x-1].is_a?(Void)
          new_portal = Portal.new(x, y, mazeitem.val + @maze[y][x+1].val, @maze[y][x-1], x == 1 || x == @maze[y].size - 2 ? :outer : :inner)
          @maze[y][x-1].portal = new_portal
          @maze[y][x+1] = nil

        elsif @maze[y-1] && @maze[y+1] && @maze[y-1][x].is_a?(PortalCode) && @maze[y+1][x].is_a?(Void)
          new_portal = Portal.new(x, y, @maze[y-1][x].val + mazeitem.val, @maze[y+1][x], y == 1 || y == @maze.size - 2 ? :outer : :inner)
          @maze[y+1][x].portal = new_portal
          @maze[y-1][x] = nil

        elsif @maze[y-1] && @maze[y+1] && @maze[y+1][x].is_a?(PortalCode) && @maze[y-1][x].is_a?(Void)
          new_portal = Portal.new(x, y, mazeitem.val + @maze[y+1][x].val, @maze[y-1][x], y == 1 || y == @maze.size - 2 ? :outer : :inner)
          @maze[y-1][x].portal = new_portal
          @maze[y+1][x] = nil

        end

        @maze[y][x] = new_portal unless new_portal.nil?

      end
    end

    portals = @maze.flatten.select{ |i| i.is_a?(Portal) }
    portals.each do |p|
      p.other_side = portals.detect{ |p2| p2 != p && p2.code == p.code }
    end

    @portals = portals

  end

  def [](x, y)
    @maze[y] ? @maze[y][x] : nil
  end

  def []=(x,y,mazitem)
    @maze[y][x] = mazitem
  end

  def to_s
    @maze.map{ |row| row.map{ |mi| mi ? mi.icon : ' ' }.join('') }.join("\n")
  end

  def position(unit)
    idx = @maze.flatten.index(unit)
    [idx % @maze.size, (idx / @maze.size).to_i]
  end

  def width
    @maze.first.size
  end

  def move(unit, to_mazeitem)
    self[unit.x, unit.y] = Void.new(unit.x, unit.y)
    self[to_mazeitem.x, to_mazeitem.y] = unit
    unit.move_to(to_mazeitem.x, to_mazeitem.y)
  end




  def adjecent(unit)
    [
      self[unit.x,unit.y-1],
      self[unit.x-1,unit.y],
      self[unit.x+1,unit.y],
      self[unit.x,unit.y+1]
    ].compact
  end

  def neighbours(current)
    return neighbours_with_level(*current) if current.is_a?(Array)

    adjecent(current)
      .map{ |a|
        if a.is_a?(Portal)
          a.other_side.nil? ? nil : a.other_side.entry
        else
          a
        end
      }
      .compact
      .select{ |u| !u.is_a?(Wall) }
  end

  def heuristic(from, to)
    return heuristic_with_level(from, to) if from.is_a?(Array)

    if from.portal && from.portal.other_side
      1
    else
      from.distance_to(to)
    end
  end

  def distance(from, to)
    1
  end


  def neighbours_with_level(current, level)
    
    adjecent(current)
      .map{ |a|
        if level > 30
          nil
        elsif a.is_a?(Void) && !a.portal.nil? && a.portal.is_finish? && level != 0
          nil
        elsif a.is_a?(Portal)
          if a.other_side.nil?
            nil
          elsif level == 0 && a.outer?
            nil
          else
            [
              a.other_side.entry,
              a.outer? ? level - 1 : level + 1
            ]
          end
        else
          [a, level]
        end
      }
      .compact
      .select{ |u| !u.first.is_a?(Wall) }
  end

  def heuristic_with_level(from, to)
    if from.first.portal && from.first.portal.other_side
      1
    else
      from.first.distance_to(to.first)
    end
  end


end

class MazeItem

  attr_reader :x, :y

  def initialize(x,y)
    move_to(x,y)
  end

  def distance_to(other)
    (other.x - @x).abs + (other.y - @y).abs
  end

  def <=>(o)
    if @y < o.y
      -1
    elsif @y == o.y
      @x <=> o.x
    else
      1
    end
  end

  def move_to(x,y)
    @x = x
    @y = y
  end

  def to_s
    "#{self.class} @ (#{@x}, #{@y})"
  end

end

class You < MazeItem
  def icon
    '@'
  end
end

class Unit < MazeItem
  attr_reader :val
  def initialize(x,y,val)
    super(x,y)
    @val = val
  end
  def icon
    @val
  end
  def matches?(other)
    val == other.val
  end
end

class Portal < Unit
  attr_reader :entry, :code, :dir
  attr_accessor :other_side
  def initialize(x,y,code,entry,dir)
    super(x,y,'%')
    @code = code
    @entry = entry
    @dir = dir
  end
  def is_start?; @code == "AA"; end
  def is_finish?; @code == "ZZ"; end
  def inner?; @dir == :inner; end
  def outer?; @dir == :outer; end
  def to_s
    "#{self.class} #{self.code} @ (#{@x}, #{@y})"
  end
end

class PortalCode < Unit; end
class Void < MazeItem
  attr_accessor :portal
  def icon; '.'; end
end
class Wall < MazeItem; def icon; '#'; end; end

input = File.readlines("input").map{ |l| l.chomp.split('') }


start = Time.now
maze = Maze.new(input)
part1 = astar(
  maze,
  maze.portals.detect(&:is_start?).entry,
  maze.portals.detect(&:is_finish?).entry
).size - 1
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
maze = Maze.new(input)
part2 = astar(
  maze,
  [maze.portals.detect(&:is_start?).entry,0],
  [maze.portals.detect(&:is_finish?).entry,0]
).size - 1
puts "Part 2: #{part2} (#{Time.now - start}s)"