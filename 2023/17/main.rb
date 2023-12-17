require '../util/grid'
require '../util/astar'


class City < Grid
  include AStar

  DIRS = [[0,-1],[1,0],[0,1],[-1,0]]

  def part2!
    @part2 = true
    self
  end

  def as_neighbours(current)
    pos, dir, straight_steps = current
    neighbours = []

    DIRS.each do |d|
      next if @part2 && straight_steps < 4 && (!dir.nil? && d != dir)

      npos = [pos[0]+d[0],pos[1]+d[1]]
      next if self[npos].nil?

      if dir == d
        unless straight_steps == (@part2 ? 10 : 3)
          neighbours << [npos, d, straight_steps + 1]
        end
      else
        neighbours << [npos, d, 1]
      end
    end

    neighbours
  end

  def as_heuristic(from, to)
    to[0][0] - from[0][0] + to[0][1] - from[0][1]
  end

  def as_distance(from, to)
    self[to[0]]
  end

  def as_at_goal?(check, goal)
    check[0] == goal && (!@part2 || check[2] >= 4)
  end

  def as_backtracks?(cameFrom, cur, nxt)
    return false if cameFrom[cur].nil?
    cameFrom[cur][0] == nxt[0]
  end

end


start = Time.now
input = File.readlines("input", chomp: true).map{ _1.chars.map(&:to_i) }
city = City.new(input)
strt = [[0,0],nil,0]
goal = [city.col_count-1,city.row_count-1]
puts "Prep: #{Time.now - start}s"


start = Time.now
part1 = city.astar(strt, goal).drop(1).sum{ city[_1[0]] }
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = city.part2!.astar(strt, goal).drop(1).sum{ city[_1[0]] }
puts "Part 2: #{part2} (#{Time.now - start}s)"