require '../util/grid'
require 'set'


start = Time.now
input = File.readlines("input", chomp: true).map(&:chars)
gardens = Grid.new(input)
puts "Prep: #{Time.now - start}s"


def walk(gardens, start, steps)
  poss = Set.new([start])
  res = [nil]

  steps.times do |i|
    poss = poss.inject(Set.new) do |ps,c|
      gardens.each_adj(c) do |ac,v|
        ps << ac if gardens[ac] != "#"
      end
      ps
    end
    res << poss.size
  end

  res
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

# ys = []
# ys << walk(gardens, spos, sizec).size
# puts "Got y0: #{ys.last}..."
# ys << walk(gardens, spos, sizec + size).size
# puts "Got y1: #{ys.last}..."
# ys << walk(gardens, spos, sizec + size * 2).size
# puts "Got y2: #{ys.last}..."
ys = [3868,34368,95262]

# Define a, b and c
a = (ys[0] - 2*ys[1] + ys[2]) / 2;
b = (-3*ys[0] + 4*ys[1] - ys[2]) / 2;
c = ys[0]
puts "Formula is: #{a}x² + #{b}x + #{c}"

# Calculate
x = STEPS / size
part2 = a*x**2 + b*x + c
puts "Part 2: #{part2} (#{Time.now - start}s)"







# At step 65
#            
#            
#            
#     /\     
#     \/     
#            
#            
#            
# 3868

# At step 65 + 131 = 196
#     /\     
#   / OO \   
#            
#  /O OO O\  
#  \O OO O/  
#            
#   \ OO /   
#     \/     
# 7584 + 2x(991+1005) + 2x(5719+5732) = 34478 (110 diff)

# At step 65 + 131 + 131 = 327
#        /\        
#      / OO \      
#                  
#     /O OO O\     
#   / OO OO OO \   
#                  
#  /O OO OO OO O\  
#  \O OO OO OO O/  
#                  
#   \ OO OO OO /   
#     \O OO O/     
#                  
#      \ OO /      
#        \/        
# 3x7584 + 2x7613 + 4x(991+1005) + 2x(6700+6701) + 2x(5719+5732) = 95666 (404 diff)


# Rhombus:    3868
# Filled:     7584 / 7613
# Diag small: 991 / 1005
# Diag large: 6700 / 6701
# Corner:     5719 / 5732

center = walk(gardens, spos, sizec + 2 * size)
corner_t = walk(gardens, [sizec,size-1], sizec + 2 * size)
corner_r = walk(gardens, [0,sizec], sizec + 2 * size)
corner_b = walk(gardens, [sizec,0], sizec + 2 * size)
corner_l = walk(gardens, [size-1,sizec], sizec + 2 * size)

center[sizec]
center[sizec + size]
center[sizec + 2 * size]
# 3868
# 7613
# 7584
# Further: 7613, 7584 etc


# TODO:
# - Walk for each of the possible tile states:
#   - Rhombus
#   - Filled
#   - Corners, T/R/B/L
#   - Small diag TR/BR/BL/TL
#   - Large diag TR/BR/BL/TL
# - Calculate how many of each type we have at the target step
# - Multiply



# # spos = [0,sizec]
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

