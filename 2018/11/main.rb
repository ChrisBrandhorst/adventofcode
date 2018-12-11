GRID_SIZE = 300
grid_serial = 1309

grid = []

(1..300).each do |y|
  grid[y] = []
  (1..300).each do |x|
    rack_id = x + 10
    grid[y][x] = ((rack_id * y + grid_serial) * rack_id).to_s[-3].to_i - 5
  end
end

def max_level(grid, size)
  max = 0
  max_x = 0
  max_y = 0
  (1..300-size-1).each do |y|
    (1..300-size-1).each do |x|
      
      sum = grid[y, size].sum{ |r| r[x, size].sum }

      if sum > max
        max = sum
        max_x = x
        max_y = y
      end

    end
  end

  {
    max_x:  max_x,
    max_y:  max_y,
    size:   size,
    max:    max
  }
end

part1 = max_level(grid, 3)
puts "Part1: #{part1[:max_x]},#{part1[:max_y]}"

size = 1
maxes = []
while (l = max_level(grid, size))[:max] > 0
  maxes << l
  size += 1
end

part2 = maxes.max{ |a,b| a[:max] <=> b[:max] }
puts "Part2: #{part2[:max_x]},#{part2[:max_y]},#{part2[:size]}"