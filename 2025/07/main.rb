require_relative '../util/time'
require 'set'

def prep
  File.readlines("input", chomp: true)
    .select.with_index{ _2.even? }
    .map{ Set.new( _1.chars.map.with_index{ |v,i| v == "." ? nil : i }.compact ) }
end

def part1(input)
  row_beams = Set.new(input.first)
  input.inject(0) do |c,row|
    row_beams = row_beams.each_with_object(Set.new) do |bx,bs|
      if row.include?(bx)
        bs << bx - 1
        bs << bx + 1
        c += 1
      else
        bs << bx
      end
    end
    c
  end
end

def paths(input, beam, cache)
  return cache[beam] unless cache[beam].nil?

  path_count = 0
  not_split = [beam]
  while not_split.any?
    i, row = not_split.pop.clone
    row += 1

    if row == input.size
      path_count += 1
    elsif input[row].include?(i)
      path_count += paths(input, [i-1,row], cache) + paths(input, [i+1,row], cache)
    else
      not_split << [i, row]
    end
  end
 
  cache[beam] = path_count
end

def part2(input)
  paths(input, [input.first.first, 0], {})
end

input = time("Prep", false){ prep }
time("Part 1"){ part1(input) }
time("Part 2"){ part2(input) }