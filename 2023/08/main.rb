start = Time.now
input = File.readlines("input", chomp: true)

dirs = input.shift.chars
network = input.drop(1).map{ _1.scan(/([A-Z\d]+)/).map(&:first) }.map{ [_1, [_2,_3]] }.to_h
puts "Prep: #{Time.now - start}s"


start = Time.now

pos = "AAA"
dir = 0
steps = 0
until pos == "ZZZ"
  steps += 1
  i = dirs[dir] == "L" ? 0 : 1
  pos = network[pos][i]
  
  dir += 1
  dir = 0 if dir == dirs.size
end

part1 = steps
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now

poss = network.keys.select{ _1[-1] == "A" }
paths = poss.map{ [_1] }
steps = 0

1000.times do
  dirs.each do |dir|
    i = dir == "L" ? 0 : 1
    paths.each do |path|
      path << network[path.last][i]
    end
  end
end

starts = []
gcds = paths.map do |path|
  zpos = path.detect{ _1[-1] == "Z" }
  is = path.each_index.select{ path[_1] == zpos }
  dists = is.each_cons(2).map{ _2 - _1 }
  dists.inject(0, :gcd)
end

part2 = gcds.inject(1, :lcm)

puts "Part 2: #{part2} (#{Time.now - start}s)"