require '../util/infinite_grid.rb'

start = Time.now
input = File.read("input").chars
ROCKS = "-+L|O".chars
CAVE_WIDTH = 7
puts "Prep: #{Time.now - start}s"


def rock_info(r, x, y)
  case r
  when "-" then { area: [[x,y], [x+1,y], [x+2,y], [x+3,y]], width: 4 }
  when "+" then { area: [[x+1,y], [x,y+1], [x+1,y+1], [x+2,y+1], [x+1,y+2]], width: 3 }
  when "L" then { area: [[x,y], [x+1,y], [x+2,y], [x+2,y+1], [x+2,y+2]], width: 3 }
  when "|" then { area: [[x,y], [x,y+1], [x,y+2], [x,y+3]], width: 1 }
  when "O" then { area: [[x,y], [x+1,y], [x,y+1], [x+1,y+1]], width: 2 }
  end
end

def fits?(grid, r, x, y)
  ri = rock_info(r, x, y)
  !ri[:area].any?{ grid[_1] == "#" } && x >= 0 && x + ri[:width] <= CAVE_WIDTH && y >= 0
end

def find_pattern(arr, pl)
  (0..arr.size-pl).each do |i|
    occs = [i]
    pat = arr[i,pl]
    (i+1..arr.size-pl).each do |j|
      occs << j if arr[j,pl] == pat
      return [arr[occs.first,occs.last-occs.first], occs.first] if occs.size == 2
    end
  end
end


start = Time.now

cave = InfiniteGrid.new([[]])
rocks = ROCKS.dup
jets = input.dup
height_increments = []
total_height = 0

2022.times do

  r = rocks.shift
  rocks << r

  rx, ry = [2,cave.max_y+4]
  while j = jets.shift
    jets << j

    case j
    when "<" then rx -= 1 if fits?(cave, r, rx-1, ry)
    when ">" then rx += 1 if fits?(cave, r, rx+1, ry)
    end

    if fits?(cave, r, rx, ry-1)
      ry -= 1
    else
      rock_info(r, rx, ry)[:area].each{ cave[_1] = "#" }
      new_height = cave.max_y + 1
      height_increments << new_height - total_height
      total_height = new_height
      break
    end

  end
end

part1 = total_height
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
rock_count = 1000000000000
pattern, first_occ = find_pattern(height_increments, 20)
end_count = (rock_count - first_occ) % pattern.size
part2 = height_increments[0,first_occ].sum +
  (rock_count - first_occ - end_count) / pattern.size * pattern.sum +
  pattern[0,end_count].sum
puts "Part 2: #{part2} (#{Time.now - start}s)"