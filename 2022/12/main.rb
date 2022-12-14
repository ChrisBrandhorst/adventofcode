require '../util/grid.rb'
require '../util/astar.rb'

class Heightmap < Grid

  attr_reader :start, :end

  def initialize(rows)
    super(rows)

    self.each do |c,v|
      if v == "S"
        self[c] = "a"
        @start = c
      elsif v == "E"
        self[c] = "z"
        @end = c
      end
    end
  end

  def neighbours(cur)
    self.adj_coords(cur).select{ self[*_1].ord - self[*cur].ord <= 1 }
  end

  def heuristic(from, to)
    (from.first - to.first).abs + (from.last - to.last).abs
  end

  def distance(from, to)
    1
  end

end

start = Time.now
input = File.readlines("input", chomp: true).map(&:chars)
puts "Prep: #{Time.now - start}s"

start = Time.now
map = Heightmap.new(input)
part1 = astar(map, map.start, map.end).size - 1
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now


require 'set'

def search(map, path, cur, target, visited, paths)
  # return path + [cur] if grid[cur] == target

  map
    .adj_coords(cur)
    .select{ !visited.include?(_1) && map[cur].ord - map[_1].ord <= 1 }
    .inject(paths){ |ps,t|
      visited << t
      path = path.dup + [t]
      if map[t] == target
        paths << path
      else
        paths = search(map, path, t, target, visited, paths)
      end
      paths
    }
  
end

paths = search(map, [], map.end, "a", Set.new, Set.new)
part2 = paths.map{ _1.size - 2 }.min

# as = map.inject([]){ |r,c| r << c if map[c] == "a" && map.adj(c).include?("b"); r }
# steps = as.inject({}) do |s,ac|
#   next s if s.include?(ac)
#   path = astar(map, ac, map.end)
#   next s if path.nil?
#   path.each.with_index do |c,i|
#     if map[c] == "a"
#       s[c] = path.size - i - 1
#     else
#       break
#     end
#   end
#   s
# end

# part2 = steps.values.min
puts "Part 2: #{part2} (#{Time.now - start}s)"