require 'digest'

start = Time.now
input = File.read("input", chomp: true)
puts "Prep: #{Time.now - start}s"


def find(salt, zeros)
  s = "0" * zeros
  1.step{ break(_1) if Digest::MD5.hexdigest("#{salt}#{_1}")[0,zeros] == s }
end

start = Time.now
part1 = find(input, 5)
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = find(input, 6)
puts "Part 2: #{part2} (#{Time.now - start}s)"