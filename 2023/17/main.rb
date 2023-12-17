require '../util/grid'
require '../util/astar'

start = Time.now
input = File.readlines("input", chomp: true).map{ _1.chars.map(&:to_i) }
puts "Prep: #{Time.now - start}s"

DIRS = [[0,-1],[1,0],[0,1],[-1,0]]

class City < Grid

  def neighbours(current)
    pos, dir, straight_steps = current

    neighbours = []
    DIRS.each do |d|
      npos = [pos[0]+d[0],pos[1]+d[1]]
      next if self[npos].nil?

      if dir == d
        unless straight_steps == 3
          neighbours << [npos, d, straight_steps + 1]
        end
      else
        neighbours << [npos, d, 1]
      end
    end

    neighbours
  end

  def heuristic(from, to)
    (from[0][0] - to[0][0]).abs + (from[0][1] - to[0][1]).abs
  end

  def distance(from, to)
    self[to[0]]
  end

  def at_goal?(check, goal)
    check[0] == goal
  end

  def backtracks?(cameFrom, cur, nxt)
    return false if cameFrom[cur].nil?
    cameFrom[cur][0] == nxt[0]
  end

end

start = Time.now
city = City.new(input)

path = astar(city, [[0,0],nil,0], [city.col_count-1,city.row_count-1]).drop(1)
# p path.map{_1[1]}
hl = path.map{ city[_1[0]] }

path.each{ city[_1[0]] = "." }
# p city

part1 = hl.sum
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = nil
puts "Part 2: #{part2} (#{Time.now - start}s)"