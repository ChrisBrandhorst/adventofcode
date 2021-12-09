require 'matrix'
require_relative '../util/grid.rb'

start = Time.now
input = File.readlines("input", chomp: true).map{ |l| l.chars.map(&:to_i) }
grid = Grid.new(input)
puts "Prep: #{Time.now - start}s"

start = Time.now
part1 = grid.inject([]){ |l,c,v| l << v + 1 if grid.adj(c).all?{ |a| v < a }; l }.sum
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
basins = grid.inject([]) do |bs,c,v|
  next bs if v.nil?

  basin, queue = [], [c]
  while e = queue.shift
    if !grid[e].nil?
      if grid[e] != 9
        basin << e
        queue += grid.adj_coords(e)
      end
      grid[e] = nil
    end
  end
  bs << basin
end
part2 = basins.map(&:size).sort[-3..-1].inject(&:*)
puts "Part 2: #{part2} (#{Time.now - start}s)"