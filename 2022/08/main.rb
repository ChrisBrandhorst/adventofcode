require '../util/grid.rb'

DIRS = [[0,-1],[1,0],[-1,0],[0,1]]

start = Time.now
input = File.readlines("input", chomp: true).map{ _1.chars.map(&:to_i) }
grid = Grid.new(input)
puts "Prep: #{Time.now - start}s"


start = Time.now

part1 = grid.inject(0) do |t,c,v|
  any_vis = DIRS.inject(false) do |vis,(dx,dy)|
    visible = true
    cc = c.dup
    while visible
      cc = [cc.first+dx,cc.last+dy]
      break if grid[*cc].nil?
      visible = grid[*cc] < v
    end
    vis | visible
  end
  t + (any_vis ? 1 : 0)
end

puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now

directions = [
  input, # left to right
  input.map(&:reverse), # right to left
  input.transpose, # top to bottom
  input.transpose.map(&:reverse) # bottom to top
]

visibles = directions.map do |g|
  g.map do |r|
    rmax = -1
    r.map do |t|
      if t > rmax
        rmax = t
        1
      else
        0
      end
    end
  end
end

visibles = [
  visibles[0],
  visibles[1].map(&:reverse),
  visibles[2].transpose,
  visibles[3].map(&:reverse).transpose,
]

part1 = visibles.map(&:flatten).transpose.map{ _1.reduce(:|) }.sum
puts "Part 1 Alt: #{part1} (#{Time.now - start}s)"


start = Time.now

scores = grid.inject([]) do |s,c,v|
  s << DIRS.inject(1) do |ds,(dx,dy)|
    score = 0
    cc = c.dup
    while true
      cc = [cc.first+dx,cc.last+dy]
      break if grid[*cc].nil?
      score += 1
      break if grid[*cc] >= v
    end
    ds *= score
  end
end

part2 = scores.max
puts "Part 2: #{part2} (#{Time.now - start}s)"