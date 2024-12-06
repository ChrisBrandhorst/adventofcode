require_relative '../util/time'
require_relative '../util/grid'
require 'set'

def prep
  input = File.readlines("input", chomp: true).map(&:chars)
  grid = Grid.new(input)
  [grid, grid.detect{ _2 == "^" }]
end

def move(d, x, y)
  case d
  when 0; [x,y-1]
  when 1; [x+1,y]
  when 2; [x,y+1]
  when 3; [x-1,y]
  end
end

def walk(grid, gc, put_obs = false, dir = 0)
  path, seen, obss = Set.new, Set.new, Set.new

  loop do
    path << gc
    ngc = move(dir, gc[0], gc[1])

    if grid[ngc] == "#"
      if !put_obs
        return false if seen.include?([gc, dir])
        seen << [gc, dir]
      end
      dir = (dir + 1) % 4
    elsif grid[ngc]
      if put_obs
        grid[ngc] = "#"
        obss << ngc if walk(grid, gc, false, dir) == false
        grid[ngc] = "."
      end
      gc = ngc
    else
      break
    end
  end

  put_obs ? obss : path
end

def part1(grid, start)
  walk(grid, start).size
end

def part2(grid, start)
  walk(grid, start, true).size
end

grid, start = time("Prep", false){ prep }
time("Part 1"){ part1(grid, start) }
time("Part 2"){ part2(grid, start) }