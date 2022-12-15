require '../util/grid.rb'
require '../util/astar.rb'

class Heightmap < Grid

  attr_reader :start, :end

  def initialize(rows)
    super(rows)

    self.each do |c,v|
      if v == "S"
        self[@start = c] = "a"
      elsif v == "E"
        self[@end = c] = "z"
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

def search(map, start, target)

  q = [start]
  parents = {}
  visited = [start]
  paths = []

  until q.empty?
    c = q.shift
    if map[c] == target
      path = [c]
      path << parents[path.last] until path.last == start
      paths << path
    else
      options = map
        .adj_coords(c)
        .select{ !visited.include?(_1) && map[c].ord - map[_1].ord <= 1 }
      options.each do |t|
        visited << t
        parents[t] = c
        q << t
      end
    end
  end
  
  paths
end

part2 = search(map, map.end, "a").min_by(&:size).size - 1
puts "Part 2: #{part2} (#{Time.now - start}s)"


# Slower alternative using A*
# 
# as = map.inject([]){ |r,c| r << c if map[c] == "a" && map.adj(c).include?("b"); r }
# steps = as.inject({}) do |s,ac|
#   next s if s.include?(ac)
#   path = astar(map, ac, map.end)
#   next s if path.nil?
#   path.each.with_index do |c,i|
#     if map[c] == "a"
#       # s[c] = path.size - i - 1
#       s[c] = path[i..-1]
#     else
#       break
#     end
#   end
#   s
# end

# part2 = steps.values.min