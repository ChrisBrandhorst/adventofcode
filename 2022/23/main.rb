require "../util/infinite_grid.rb"

start = Time.now
input = File.readlines("input", chomp: true)
  .map(&:chars)

grid = InfiniteGrid.new(input)
elves = grid.select{ |c,v| v == "#" }

NW=0; N=1; NE=2; W=3; E=5; SW=6; S=7; SE=8
checks = [[N,NE,NW],[S,SE,SW],[W,NW,SW],[E,NE,SE]]

puts "Prep: #{Time.now - start}s"

start = Time.now
moved, round = true, 0

while moved && round += 1

  stayers, movers = [], {}
  moved = false

  elves.each do |e|
    adj = grid.adj_coords_values(e)

    proposed = nil
    if adj.count{ _1.last == "#" } > 1
      checks.each do |c|
        if c.map{adj[_1].last}.count("#") == 0
          proposed = adj[c.first].first
          break
        end
      end
    end

    if proposed.nil?
      stayers << e
    else
      movers[proposed] ||= []
      movers[proposed] << e
    end

  end

  elves = stayers.dup
  movers.each do |t,elvs|
    if elvs.size == 1
      e = elvs.first
      grid[e] = "."
      grid[t] = "#"
      elves << t
      moved = true
    else
      elves += elvs
    end
  end
  
  checks << checks.shift

  if round == 10
    empties_round_10 = Range.new(*elves.map{_1[1]}.minmax).sum do |y|
      Range.new(*elves.map{_1[0]}.minmax).count{ |x| grid[x,y] == "." }
    end
  end

end

part1 = empties_round_10
puts "Part 1: #{part1}"
part2 = round
puts "Part 2: #{part2} (#{Time.now - start}s)"