start = Time.now
input = File.readlines("input", chomp: true).map(&:to_i)
puts "Prep: #{Time.now - start}s"

def count_larger(inp)
  inp.each_cons(2).count{ |a,b| b > a }
end

start = Time.now
part1 = count_larger(input)
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = count_larger(input.each_cons(3).map(&:sum))
puts "Part 2: #{part2} (#{Time.now - start}s)"