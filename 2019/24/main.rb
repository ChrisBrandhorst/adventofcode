require 'set'

input = File.readlines("input").map{ |l| l.chomp.split('') }

BUG = '#'
SPACE = '.'
GRID_SIZE = input.size
raise "NotOddException" unless GRID_SIZE.odd?
GRID_CENTER = GRID_SIZE / 2

def cycle(tiles)
  tiles.each_with_index.map do |r,y|
    r.each_with_index.map do |t,x|
      bug_count = [
        y - 1 < 0 ? nil : tiles[y-1][x],
        x - 1 < 0 ? nil : tiles[y][x-1],
        tiles[y][x+1],
        tiles[y+1] ? tiles[y+1][x] : nil
      ].count{ |t| t == BUG }
      if t == BUG && bug_count != 1
        t = SPACE
      elsif t == SPACE && (bug_count == 1 || bug_count == 2)
        t = BUG
      end
      t
    end
  end
end

def cycle_until_match(current)
  seen = Set.new
  while true
    current = cycle(current)
    flat = current.flatten.join("")
    break if seen.include?(flat)
    seen << flat
  end
  current
end

start = Time.now
part1 = cycle_until_match(input).flatten.each_with_index.map{ |t,i| t == BUG ? 2 ** i : 0 }.sum
puts "Part 1: #{part1} (#{Time.now - start}s)"

@levels = { 0 => input }

def level(l)
  if @levels[l].nil?
    level = ([SPACE] * GRID_SIZE * GRID_SIZE).each_slice(GRID_SIZE).to_a
    level[GRID_CENTER][GRID_CENTER] = '?'
    @levels[l] = level
  end
  @levels[l]
end

def adjecent_with_level(l, x, y)
  return [] if level(l)[y][x] == '?'

  up = if y - 1 == -1
    level(l-1)[GRID_CENTER-1][GRID_CENTER]
  elsif y - 1 == GRID_CENTER && x == GRID_CENTER
    level(l+1).last
  else
    level(l)[y-1][x]
  end

  down = if y + 1 == GRID_SIZE
    level(l-1)[GRID_CENTER+1][GRID_CENTER]
  elsif y + 1 == GRID_CENTER && x == GRID_CENTER
    level(l+1).first
  else
    level(l)[y+1][x]
  end

  left = if x - 1 == -1
    level(l-1)[GRID_CENTER][GRID_CENTER-1]
  elsif x - 1 == GRID_CENTER && y == GRID_CENTER
    level(l+1).map{|r|r.last}
  else
    level(l)[y][x-1]
  end

  right = if x + 1 == GRID_SIZE
    level(l-1)[GRID_CENTER][GRID_CENTER+1]
  elsif x + 1 == GRID_CENTER && y == GRID_CENTER
    level(l+1).map{|r|r.first}
  else
    level(l)[y][x+1]
  end

  [up, down, left, right].flatten
end

def cycle_levels
  new_levels = {}
  
  loop do
    (@levels.keys - new_levels.keys).each do |l|
      new_levels[l] = @levels[l].each_with_index.map do |r,y|
        r.each_with_index.map do |t,x|
          bug_count = adjecent_with_level(l, x, y).count{ |t| t == BUG }
          if t == BUG && bug_count != 1
            t = SPACE
          elsif t == SPACE && (bug_count == 1 || bug_count == 2)
            t = BUG
          end
          t
        end
      end
    end

    keys = new_levels.keys.sort
    break if keys.size > 0 && (new_levels[keys.first] + new_levels[keys.last]).flatten.count{ |t| t == BUG } == 0
  end

  @levels = new_levels
end

start = Time.now
200.times{ cycle_levels }
part2 = @levels.values.flatten.count{ |t| t == BUG }
puts "Part 2: #{part2} (#{Time.now - start}s)"