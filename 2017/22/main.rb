input = File.readlines("input", chomp: true).map(&:chars)

UP, RIGHT, DOWN, LEFT = 0, 1, 2, 3
CLEAN, WEAKENED, INFECTED, FLAGGED = 0, 1, 2, 3

def start(input)
  grid = {}
  xmax, ymax = 0, 0
  input.each_with_index do |row,y|
    row.each_with_index do |v,x|
      grid[[x,y]] = v == "#" ? INFECTED : CLEAN
      xmax = x if x > xmax
      ymax = y if y > ymax
    end
  end

  [grid, [xmax / 2, ymax / 2], 0]
end

def adj(val, d, c = 4)
  val += d
  if val < 0;     val += c
  elsif val >= c; val -= c
  end
  val
end

def next_vp(vp, vd)
  case vd
  when UP;    [vp[0],   vp[1]-1]
  when RIGHT; [vp[0]+1, vp[1]]
  when DOWN;  [vp[0],   vp[1]+1]
  when LEFT;  [vp[0]-1, vp[1]]
  end
end

infect = 0
grid, vp, vd = start(input)
10000.times do

  inf = grid[vp] == INFECTED
  vd = adj(vd, inf ? 1 : -1)

  if inf
    grid[vp] = CLEAN
  else
    grid[vp] = INFECTED
    infect += 1
  end

  vp = next_vp(vp, vd)
end

puts "Part 1: #{infect}"


infect = 0
grid, vp, vd = start(input)
10000000.times do

  state = grid[vp] || CLEAN
  vd = case state
  when 0; adj(vd, -1)
  when 1; vd
  when 2; adj(vd, 1)
  when 3; adj(vd, 2)
  end

  grid[vp] = adj(state, 1)
  infect += 1 if grid[vp] == INFECTED

  vp = next_vp(vp, vd)
end

puts "Part 2: #{infect}"