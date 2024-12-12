require_relative '../util/time'
require_relative '../util/grid'
require_relative '../util/dir'
require 'set'

def prep
  input = File.readlines("input", chomp: true).map(&:chars)
  grid = Grid.new(input)
end

def calc(grid)
  plots = Set.new
  seen = Set.new

  grid.each do |c,v|
    next if seen.include?(c)

    region = Set.new
    fences = {}
    Dir.each{ fences[_1] = Set.new }

    q = [c]
    until (cc = q.shift).nil?
      next unless grid[cc] == v
      seen << cc
      region << cc
      Dir.each do |d|
        ac = d + cc
        q << ac unless region.include?(ac) || q.include?(ac)
        fences[d] << cc if grid[ac] != v
      end
    end

    perimeter = 0
    sides = fences.sum do |d,fs|
      perimeter += fs.count
      i = d.dx.abs
      fs.group_by{ _1[1-i] }.values.sum{ 1 + _1.sort.each_cons(2).count{ |a,b| b[i] != a[i] + 1 } }
    end

    plots << [region.size * perimeter, region.size * sides]
  end

  plots
end

grid = time("Prep", false){ prep }
plots = time("Calc", false){ calc(grid) }
time("Part 1"){ plots.sum(&:first) }
time("Part 2"){ plots.sum(&:last) }