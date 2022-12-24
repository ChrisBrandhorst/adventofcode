require 'set'

start = Time.now
input = File.readlines("input", chomp: true)

class World

  attr_reader :start, :finish
  attr_reader :all_blizzards

  def initialize(blizzards, max_x, max_y, start, finish)
    @max_x, @max_y = max_x, max_y
    @start, @finish = start, finish

    self.calculate_blizzards(blizzards)
  end

  def calculate_blizzards(blizzards)
    @all_blizzards = [blizzards]
    (@max_x.lcm(@max_y)-1).times do

      new_blizzards = {}
      blizzards.each do |c,ds|
        ds.each do |d|
          x, y = c
          case d
          when ">" then x += 1
          when "<" then x -= 1
          when "v" then y += 1
          when "^" then y -= 1
          end
          x = 1 if x > @max_x
          x = @max_x if x == 0
          y = 1 if y > @max_y
          y = @max_y if y == 0
          new_blizzards[[x,y]] ||= []
          new_blizzards[[x,y]] << d
        end
      end
      
      @all_blizzards << (blizzards = new_blizzards)
    end
  end

  def walk(from, to, start_min)
    min = start_min
    root = [from,min]
    visited = Set.new

    q = [root]
    while q.any?
      pos, min = q.shift
      return min if pos == to

      min += 1
      bmin = min % @all_blizzards.size
      blizzards = @all_blizzards[bmin]

      [
        [pos[0]+1,pos[1]], [pos[0]-1,pos[1]],
        [pos[0],pos[1]+1], [pos[0],pos[1]-1],
        pos
      ].each do |o|
        next unless self.in?(o) && !blizzards.key?(o) && !visited.include?([o,bmin])
        q << [o,min]
        visited << [o,bmin]
      end
    end
  end

  def in?(pos)
    pos == start || pos == finish || (pos[0] >= 1 && pos[0] <= @max_x && pos[1] >= 1 && pos[1] <= @max_y)
  end

end

blizzards = {}
(0...input.size).each do |y|
  (0...input.first.size).each do |x|
    c = input[y][x]
    blizzards[[x,y]] = [c] unless c == "." || c == "#"
  end
end
max_x = input.first.size - 2
max_y = input.size - 2
world = World.new(blizzards, max_x, max_y, [1,0], [max_x,max_y+1])

puts "Prep: #{Time.now - start}s"


start = Time.now
from, to = [1,0], [max_x, max_y + 1]
part1 = world.walk(from, to, 0)
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = world.walk(from, to, world.walk(to, from, part1))
puts "Part 2: #{part2} (#{Time.now - start}s)"