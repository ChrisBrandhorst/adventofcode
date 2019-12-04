input = File.read("input").split("-").map(&:to_i)

def run(passes)
  part1 = 0
  part2 = 0

  passes.each do |pass|
    part1_ok = part2_ok = false

    pass.each do |dec|
      c = pass.count(dec)
      part1_ok = c >= 2 if !part1_ok
      part2_ok = c == 2 if !part2_ok
      break if part1_ok && part2_ok
    end

    part1 += 1 if part1_ok
    part2 += 1 if part2_ok
  end

  [part1, part2]
end

start = Time.now
passes = (input[0]..input[1]).map(&:to_s).select{ |pass| pass.chars.sort.join == pass }.map{ |pass| pass.chars.map(&:to_i) }
puts "Building: #{Time.now-start}s"

start = Time.now
part1, part2 = run(passes)
puts "Checking: #{Time.now - start}s"

puts "Part 1: #{part1}"
puts "Part 2: #{part2}"