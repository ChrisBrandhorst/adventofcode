WATER_X = 500

# Data prep
data = File.readlines("input").map{ |l|
  l.chomp.split(', ')
    .inject({}){ |h,c|
      v = c[2..-1]
      v = v.include?('..') ? v = Range.new(*v.split('..').map(&:to_i)) : Range.new(v.to_i, v.to_i)
      c[0] == 'x' ? h[:x] = v : h[:y] = v
      h
    }
  }

# Build ground
$ground = []
$minx, $maxx = WATER_X, WATER_X
$miny, $maxy = nil, 0

data.each do |d|
  d[:y].each do |y|
    $miny = [y, $miny].compact.min
    $maxy = [y, $maxy].max
    d[:x].each do |x|
      $minx = [x, $minx].min
      $maxx = [x, $maxx].max
      $ground[y] ||= []
      $ground[y][x] = '#'
    end
  end
end

$minx -= 1
$maxx += 1
$ground = $ground.map{ |row| row.nil? ? [] : row }
$ground[0][WATER_X] = '+'

# Pretty print
def output
  $ground.each do |row|
    puts ($minx..$maxx).map{ |c| row[c].nil? ? '.' : row[c] }.join('')
  end
end

# Spring builder
def get_springs(spring_x, spring_y)
  new_springs = []

  # Find clay bottom
  clay_y = nil
  (spring_y+1..$maxy).each do |y|
    spring_row = $ground[y]
    if spring_row[spring_x] == '#'
      # We've hit clay bottom
      clay_y = y
      break
    elsif spring_row[spring_x] == '|'
      # Other spring, bail out
      break
    else
      # Run that water
      spring_row[spring_x] = '|'
    end
  end

  # No bottom? Done!
  return if clay_y.nil?

  # Go upwards, filling the bucket
  (clay_y - 1).step(by: -1) do |y|
    this_row = $ground[y]

    # Find walls
    left_x = ($minx...spring_x).to_a.reverse.detect{ |x| this_row[x] == '#' || $ground[y+1][x].nil? }
    right_x = (spring_x+1..$maxx).detect{ |x| this_row[x] == '#' || $ground[y+1][x].nil? }

    # Done
    break if left_x.nil? || right_x.nil?

    # Check situation
    is_wall_left = this_row[left_x] == '#'
    is_wall_right = this_row[right_x] == '#'
    is_between_walls = is_wall_left && is_wall_right

    # Fill row
    fill_left_x = is_wall_left ? left_x + 1 : left_x
    fill_right_x = is_wall_right ? right_x - 1 : right_x
    (fill_left_x..fill_right_x).each{ |x| this_row[x] = is_between_walls ? '~' : '|' }

    # Generate new springs
    if !is_between_walls
      new_springs << [left_x, y] if !is_wall_left
      new_springs << [right_x, y] if !is_wall_right
      return new_springs
    end

  end

  return new_springs
end

springs = [[WATER_X,0]]
until springs.empty? do
  springs = springs.map{ |s| get_springs(s.first, s.last) }.flatten(1).compact
end

water = $ground[$miny..$ground.size].flatten
rest_water = water.count{ |c| c == '~' }
running_water = water.count{ |c| c == '|' }

part1 = rest_water + running_water
puts "Part 1: #{part1}"
puts "Part 2: #{rest_water}"