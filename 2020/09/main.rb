PREAMBLE = 25

def get_part2(input, part1)
  2.step do |size|
    set = input.each_cons(size).find{ |r| r.sum == part1 }
    return set.min + set.max unless set.nil?
  end
end

start = Time.now
input = File.readlines("input").map(&:to_i)
puts "Prep: #{Time.now - start}s"

start = Time.now
part1 = input.find.with_index{ |n,i| i >= PREAMBLE && !input[i-PREAMBLE..i-1].combination(2).find{ |c| c.sum == n } }
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = get_part2(input, part1)
puts "Part 2: #{part2} (#{Time.now - start}s)"