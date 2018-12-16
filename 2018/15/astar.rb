require 'set'

def astar(grid, start, goal)
  closed_set = Set[]
  open_set = Set[start]
  cameFrom = {}
  gScore = {}
  gScore[start] = 0
  fScore = {}
  fScore[start] = start.distance_to(goal)
  
  until open_set.empty? do
    current = open_set.min{ |a,b| fScore[a] <=> fScore[b] }

    if current == goal
      total_path = [current]
      while cameFrom.keys.include?(current)
        current = cameFrom[current]
        total_path << current
      end
      return total_path.reverse
    end

    open_set.delete(current)
    closed_set << current

    neighbours(grid, current).each do |neighbour|
      next if closed_set.include?(neighbour)
      
      tentative_gScore = gScore[current] + 1

      if !open_set.include?(neighbour)
        open_set << neighbour
      elsif tentative_gScore >= gScore[neighbour]
        next
      end

      cameFrom[neighbour] = current
      gScore[neighbour] = tentative_gScore
      fScore[neighbour] = gScore[neighbour] + distance(grid, neighbour, goal)

    end

  end
  
end

def neighbours(grid, current)
  grid.adjecent(current).select{ |n| n.is_a?(Void) }
end

def distance(grid, from, to)
  from.distance_to(to)
end