input = 277678

def get_coords(square)
  # Square width
  width = Math.sqrt(square).ceil
  width += 1 if width % 2 == 0
  # Number of squares
  count = (width - 1) * 4
  # Final square
  last = width * width
  # First square
  first = last - count
  # Position within this rotation (0-base)
  pos = square - first
  # Side (0: east, 1: north, 2: west, 3: south)
  side = width == 1 ? 0 : (pos - 1) / (width - 1)
  # Ring no (0-base)
  ring = (width / 2).floor
  # Distance to center
  dist = pos - ( ring + side * (width - 1) )

  if side == 0
    { x: ring, y: dist }
  elsif side == 1
    { x: -dist, y: ring }
  elsif side == 2
    { x: -ring, y: -dist }
  else
    { x: dist, y: -ring }
  end
end

# Manhattan distance
coords = get_coords(input)
steps = coords[:x].abs + coords[:y].abs
puts "Part 1: #{steps}"


cur = 1
i = 1
grid = {0 => {0 => 1}}

def grid_value(grid, coords, val = 0)
  a = grid[coords[:x]] ||= {}
  a[coords[:y]] = val if val > 0
  a[coords[:y]] || 0
end

while cur < input

  i += 1
  center = get_coords(i)
  
  cur = (2..9).inject(0) do |cur,n|
    offset = get_coords(n)
    target = { x: center[:x] + offset[:x], y: center[:y] + offset[:y] }
    cur + grid_value(grid, target)
  end

  grid_value(grid, center, cur)

end

puts "Part 2: #{cur}"