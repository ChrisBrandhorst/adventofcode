start = Time.now
input = File.readlines("input", chomp: true).map(&:to_i)
puts "Prep: #{Time.now - start}s"

def count_larger(inp, window)
  inp.each_cons(window).count{ |a| a.last > a.first }
end

start = Time.now
part1 = count_larger(input, 2)
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = count_larger(input, 4)
puts "Part 2: #{part2} (#{Time.now - start}s)"