start = Time.now
input = File.read("input")
puts "Prep: #{Time.now - start}s"


def look_and_say(str, times = 40)
  times.times do
    parts = str.to_enum(:scan, /(\d)\1{0,}/).map{$&}
    str = parts.map{ "#{_1.size}#{_1[0]}" }.join
  end
  str
end

start = Time.now
part1 = look_and_say(input).size
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = look_and_say(input, 50).size
puts "Part 2: #{part2} (#{Time.now - start}s)"