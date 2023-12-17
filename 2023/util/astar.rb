require 'set'
require_relative '../util/priority_queue.rb'

module AStar

  def astar(start, goal)
    self.as_reset!
    cameFrom = {}
    gScore = {}
    gScore[start] = 0
    fScoreStart = self.as_heuristic(start, goal)

    open_set = PriorityQueue.new
    open_set << [start, -fScoreStart]

    until open_set.empty? do
      current = open_set.pop

      if self.as_at_goal?(current, goal)
        total_path = [current]
        total_path << current while current = cameFrom[current]
        return total_path.reverse
      end

      self.as_seen(current)
      self.as_neighbours(current).each do |neighbour|
        next if self.as_seen?(neighbour)
        tentative_gScore = gScore[current] + self.as_distance(current, neighbour)

        if !gScore[neighbour] || tentative_gScore <= gScore[neighbour]
          cameFrom[neighbour] = current
          gScore[neighbour] = tentative_gScore
          fScoreNeighbour = tentative_gScore + self.as_heuristic(neighbour, goal)

          if !open_set.include?(neighbour) && !self.as_backtracks?(cameFrom, current, neighbour)
            open_set << [neighbour, -fScoreNeighbour]
          end
        end

      end

    end
    
  end

  def as_neighbours; throw new NotImplementedError; end
  def as_heuristic; throw new NotImplementedError; end
  def as_distance; throw new NotImplementedError; end
  def as_at_goal; throw new NotImplementedError; end
  def as_backtracks; throw new NotImplementedError; end
  def as_reset!; end
  def as_seen(current); end
  def as_seen?(neighbour); end

end