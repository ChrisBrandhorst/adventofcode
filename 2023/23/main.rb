require '../util/grid'
require 'set'

class Trails < Grid

  def neighbours(c)
    x,y = c
    case self[c]
    when "."
      self.adj_coords(c).reject{ self[_1] == "#" }
    when ">"
      self[x+1,y] ? [[x+1,y]] : []
    when "v"
      self[1,y+1] ? [[x,y+1]] : []
    else
      []
    end
  end

end


start = Time.now
input = File.readlines("input", chomp: true).map(&:chars)
trails = Trails.new(input)
source = [1,0]
target = [trails.col_count-2,trails.row_count-1]
puts "Prep: #{Time.now - start}s"


def longest_path_and_distances(grid, node, target, last_cross, distances, seen = Set.new, length = 0, last_cross_length = 0)
  seen << node
  longest = 0
  if node == target
    longest = length
  else
    neighbours = grid.neighbours(node)
    cross = neighbours.size > 2
    neighbours.each do |n|
      next if seen.include?(n)
      len = longest_path_and_distances(grid, n, target, cross ? node : last_cross, distances, seen, length + 1, cross ? 1 : last_cross_length + 1)
      longest = len if len > longest
    end
  end

  if node == target || cross
    (distances[last_cross] ||= {})[node] = last_cross_length
    (distances[node] ||= {})[last_cross] = last_cross_length
  end

  seen.delete(node)
  longest
end

start = Time.now
distances = {}
part1 = longest_path_and_distances(trails, source, target, source, distances)
puts "Part 1: #{part1} (#{Time.now - start}s)"


def longest_path(distances, node, target, seen = Set.new, length = 0)
  seen << node
  longest = 0
  if node == target
    longest = length
  else
    distances[node].each do |n,d|
      next if seen.include?(n)
      len = longest_path(distances, n, target, seen, length + d)
      longest = len if len > longest
    end
  end
  seen.delete(node)
  longest
end

start = Time.now
part2 = longest_path(distances, source, target)
puts "Part 2: #{part2} (#{Time.now - start}s)"