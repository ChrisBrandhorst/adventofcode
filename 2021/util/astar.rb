require 'set'
require_relative '../util/priority_queue.rb'

def astar(grid, start, goal)
  closed_set = Set[]
  cameFrom = {}
  gScore = {}
  gScore[start] = 0
  fScore = {}
  fScore[start] = h(grid, start, goal)

  open_set = PriorityQueue.new
  open_set << [start, -fScore[start]]

  until open_set.empty? do
    current = open_set.pop

    if current == goal
      total_path = [current]
      while cameFrom.keys.include?(current)
        current = cameFrom[current]
        total_path << current
      end
      return total_path.reverse
    end

    closed_set << current
    
    grid.neighbours(current).each do |neighbour|
      next if closed_set.include?(neighbour)

      tentative_gScore = gScore[current] + d(grid, current, neighbour)

      if !gScore[neighbour] || tentative_gScore < gScore[neighbour]
        cameFrom[neighbour] = current
        gScore[neighbour] = tentative_gScore
        fScore[neighbour] = gScore[neighbour] + h(grid, neighbour, goal)

        if !open_set.include?(neighbour)
          open_set << [neighbour, -tentative_gScore]
        end
      end

    end

  end
  
end

def h(grid, from, to)
  grid.heuristic(from, to)
end

def d(grid, from, to)
  grid.distance(from, to)
end