start = Time.now
#input = File.readlines("input", chomp: true)
input = File.readlines("aoc_2022_day05_large_input-3.txt", chomp: true)

rows, moves = input.slice_after("").to_a
stacks = rows[0...-2].map{ |r| r.chars.select.with_index{ (_2-1) % 4 == 0 } }.transpose.map{ (_1 - [" "]).reverse }
moves.map!{ |m| m.scan(/\d+/).map(&:to_i) }
puts "Prep: #{Time.now - start}s"

start = Time.now
stacks1 = stacks.map(&:dup)
moves.each{ |count, from, to| count.times{ stacks1[to-1] << stacks1[from-1].pop } }
part1 = stacks1.map(&:last).join
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
stacks2 = stacks.map(&:dup)
moves.each{ |count, from, to| stacks2[to-1] += stacks2[from-1].pop(count) }
part2 = stacks2.map(&:last).join
puts "Part 2: #{part2} (#{Time.now - start}s)"