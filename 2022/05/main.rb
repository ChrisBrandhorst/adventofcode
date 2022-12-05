start = Time.now
input = File.readlines("input", chomp: true)

rows, moves = [], []
input.each do |i|
  next if i == "" || i[1] == "1"
  if i[0] == "m"
    moves << i.scan(/\d+/).map(&:to_i)
  else
    rows << i.chars.select.with_index{ |_,j| (j - 1) % 4 == 0 }
  end
end

stacks = rows.transpose.map{ |s| s.select{ |c| c != " "}.reverse }
puts "Prep: #{Time.now - start}s"

start = Time.now
stacks1 = stacks.dup
moves.each{ |count, from, to| count.times{ stacks1[to-1] << stacks1[from-1].pop } }
part1 = stacks1.map(&:last).join
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
stacks2 = stacks.dup
moves.each{ |count, from, to| stacks2[to-1] += stacks2[from-1].pop(count) }
part2 = stacks2.map(&:last).join
puts "Part 2: #{part2} (#{Time.now - start}s)"