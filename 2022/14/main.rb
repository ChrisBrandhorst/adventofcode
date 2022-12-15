require '../util/infinite_grid.rb'

class Integer
  def to(other, &block)
    other < self ? self.downto(other, &block) : self.upto(other, &block)
  end
end

start = Time.now
input = File.readlines("input", chomp: true)
  .map{ |i| i.split(" -> ").map{ |c| c.split(",").map(&:to_i) } }

def build_cave(input)
  cave = InfiniteGrid.new([[]])

  input.each do |l|
    l.each_cons(2) do |a,b|
      a.last.to(b.last) do |y|
        a.first.to(b.first) do |x|
          cave[x,y] = "#"
        end
      end
    end
  end

  cave
end


def fill_cave(cave, start)
  begin
    # New grain
    sand = start.dup

    until sand.nil?
      check_sand = sand.dup

      # Go down
      check_sand[1] += 1
      if check_sand[1] > cave.max_y
        sand = nil
        next
      elsif cave[check_sand] == "."
        sand = check_sand
        next
      end

      # Check down-left
      check_sand[0] -= 1
      if cave[check_sand] == "."
        sand = check_sand
        next
      end

      # Check down-right
      check_sand[0] += 2
      if cave[check_sand] == "."
        sand = check_sand
        next
      end

      # Obstruction
      break
    end

    # We have landed
    cave[sand] = "o" unless sand.nil?

    # End if nothing is possible or we reached the top
  end while !sand.nil? && sand != start

  cave
end

SAND_START = [500,0]

puts "Prep: #{Time.now - start}s"

start = Time.now
cave = build_cave(input)
part1 = fill_cave(cave, SAND_START).points.count{ _2 == "o" }
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now

cave = build_cave(input)
floor_y = cave.max_y + 2
(SAND_START.first-floor_y-1..SAND_START.first+floor_y+1).each{ cave[_1,floor_y] = "#" }
part2 = fill_cave(cave, SAND_START).points.count{ _2 == "o" }
puts "Part 2: #{part2} (#{Time.now - start}s)"