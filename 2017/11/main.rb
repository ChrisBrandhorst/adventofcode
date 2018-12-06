input = File.read("input").split(',').map(&:to_sym)

dirs = {
  n:  {x:  0,   y:  1},
  ne: {x:  0.5, y:  0.5},
  se: {x:  0.5, y: -0.5},
  s:  {x:  0,   y: -1},
  sw: {x: -0.5, y: -0.5},
  nw: {x: -0.5, y:  0.5}
}

def get_min_steps(pos)
  x_steps = pos[:x].abs * 2
  y_steps = pos[:y].abs * 2

  if x_steps >= y_steps
    x_steps
  else
    x_steps + (y_steps - x_steps) / 2
  end
end

@distances = []
def move_and_track_max(pos, dir)
  n = pos.merge(dir){ |k, a, b| a + b }
  @distances << get_min_steps(n)
  n
end

final = input.inject({x: 0, y: 0}){ |pos,i| move_and_track_max(pos, dirs[i]) }
puts "Part 1: #{get_min_steps(final)}"
puts "Part 2: #{@distances.max}"