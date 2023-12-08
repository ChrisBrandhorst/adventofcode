start = Time.now
input = File.readlines("input", chomp: true)
dirs = input.shift.chars
network = input.drop(1).map{ r = _1.scan(/[A-Z]+/); [r.shift, r] }.to_h
puts "Prep: #{Time.now - start}s"


def steps_until(dirs, network, pos, &block)
  0.step do |s|
    break s if yield(pos)
    i = dirs[s % dirs.size] == "L" ? 0 : 1
    pos = network[pos][i]
  end
end


start = Time.now
part1 = steps_until(dirs, network, "AAA"){ _1 == "ZZZ" }
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = network.keys
  .select{ _1[-1] == "A" }
  .map{ |pos| steps_until(dirs, network, pos){ _1[-1] == "Z" } }
  .inject(1, :lcm)
puts "Part 2: #{part2} (#{Time.now - start}s)"