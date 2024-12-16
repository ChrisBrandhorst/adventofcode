require_relative '../util/time'
require_relative '../util/grid'
require_relative '../util/priority_queue'
require_relative '../util/dir'
require 'set'

def prep
  input = File.readlines("input", chomp: true).map(&:chars)
  Grid.new(input)
end

def find_path(map)
  start, fin, dir = map.detect("S"), map.detect("E"), [1,0]
  mem, best, best_tiles = {}, Float::INFINITY, Set[]

  q = PriorityQueue.new
  q << [[start], dir, 0]

  until q.empty?
    path, dir, score = q.pop
    cur = path.last

    next if score > best
    if cur == fin
      best_tiles = Set[] if score < best
      best_tiles += path
      best = score
    end
    mem[[cur,dir]] = score

    Dir.each do |d|
      c = d + cur
      next if map[c] == "#"
      mem_score = mem[[c,d]]
      c_score = score + (d == dir ? 1 : 1001)
      q.push([path + [c], d, c_score], -c_score) if !mem_score || mem_score > c_score
    end
  end

  [best, best_tiles.size]
end

map = time("Prep", false){ prep }
part1, part2 = time("Calc", false){ find_path(map) }
puts "Part 1: #{part1}"
puts "Part 2: #{part2}"