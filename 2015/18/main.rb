require_relative '../util/grid.rb'

start = Time.now
input = File.readlines("input", chomp: true)
puts "Prep: #{Time.now - start}s"


def game_of_life(grid, times, part2 = false)
  if part2
    corners = [[0,0], [0,grid.row_count-1], [grid.col_count-1,0], [grid.col_count-1,grid.row_count-1]]
    corners.each{ grid[_1] = "#"}
  end

  times.times do
    changes = {}
    grid.each do |c,v|
      next if part2 && corners.include?(c)
      noc = grid.adj(c).count("#")
      if v == "#"
        changes[c] = "." if noc < 2 || noc > 3
      else
        changes[c] = "#" if noc == 3
      end
    end
    changes.each{ grid[_1] = _2 }
  end
  grid
end

start = Time.now
grid = Grid.new(input.map(&:chars))
grid.with_diag!
part1 = game_of_life(grid, 100).flatten.count("#")
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
grid = Grid.new(input.map(&:chars))
grid.with_diag!
part2 = game_of_life(grid, 100, true).flatten.count("#")
puts "Part 2: #{part2} (#{Time.now - start}s)"