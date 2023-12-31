require '../util/grid'
require 'set'


start = Time.now
input = File.readlines("input", chomp: true).map(&:chars)
gardens = Grid.new(input)
puts "Prep: #{Time.now - start}s"


def walk(gardens, start, steps)
  dadj = [[0,-1],[1,0],[0,1],[-1,0]]
  poss = Set.new([start])

  steps.times.inject([nil]) do |res,i|
    poss = poss.inject(Set.new) do |ps,c|
      dadj.each do |dx,dy|
        x, y = ac = [c[0]+dx,c[1]+dy]
        ps << ac if gardens[x % gardens.col_count, y % gardens.row_count] != "#"
      end
      ps
    end
    res << poss.size
  end
end


start = Time.now
spos = gardens.detect{ _2 == "S" }
part1 = walk(gardens, spos, 64).last
puts "Part 1: #{part1} (#{Time.now - start}s)"


# You can see that whilst walking, the possible positions form a rhombus with right
# angles (a square rotated 45 deg).
# 
# Also note: (STEPS - SIZE/2) / SIZE is a nice round number: 202300.
# That means we have cycle of length SIZE with start SIZE/2.
# 
# After the first SIZE/2 steps, the corners of the rhombus are at the edge of the initial grid.
# After each next SIZE steps, the corners are at the edge of the next grid.
# 
# The rhombus is composed of:
# C. Four corner grids, which are filled as sosceles triangles: ^, >, v and <
# B. The edge grids (minus the corners), which are filled as right-angle triangles: \ and /
# A. The contained grids, which are completely filled
# 
# Whilst growing:
# - The number of C grids stays constant
# - The number of B grids grows linearly
# - The number of A grids growns quadratically
# 
# This very much looks like quadratic growth. Thus we hypothesize that the number of possible
# positions is based on a quadratic formula.
# The amout of positions can be given by f(x) = ax^2 + bx + c, where x is the number of cycles.
# To define a, b and c in , we need three points, so we calculate the positions for the first
# three cycles, which correspond to x = 0, x = 1 and x = 2.

start = Time.now
STEPS = 26501365
size = gardens.row_count
sizec = size / 2

# Get three points
ys = walk(gardens, spos, sizec + size * 2).values_at(sizec, sizec + size, sizec + size * 2)

# Define a, b and c
a = (ys[0] - 2*ys[1] + ys[2]) / 2;
b = (-3*ys[0] + 4*ys[1] - ys[2]) / 2;
c = ys[0]
puts "Formula is: #{a}x² + #{b}x + #{c}"

# Calculate
x = STEPS / size
part2 = a*x**2 + b*x + c
puts "Part 2: #{part2} (#{Time.now - start}s)"











# poss = Set.new([spos])
# 0.step do |i|
#   p gardens
#   puts "Step #{i}: #{poss.size} positions"
#   gets
#   poss = poss.inject(Set.new) do |ps,c|
#     gardens[c] = "."
#     gardens.each_adj(c) do |ac,v|
#       if v != "#"
#         ps << ac
#         gardens[ac] = "O"
#       end
#     end
#     ps
#   end
# end
