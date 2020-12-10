start = Time.now
input = File.readlines("input").map(&:to_i).sort
input.unshift(0)
input << input.max + 3
puts "Prep:   #{Time.now - start}s"

def get_path_count(graph, a, b, known = {})
  return 1 if a == b
  known[a] = graph[a].sum{ |i| known[i] || get_path_count(graph, i, b, known) }
end

start1 = Time.now
diffs = input.each_cons(2).map{ |a| a.last - a.first }
part1 = diffs.count(1) * diffs.count(3)
puts "Part 1: #{part1} (#{Time.now - start1}s)"

start2p = Time.now
graph = input.each_with_index.inject({}){ |g,(a,i)| g[a] = input[i+1,3].select{ |b| b - a <= 3 }; g }
part2p_time = Time.now - start2p
puts "Prep:   #{part2p_time}s"

start2a = Time.now
part2a = get_path_count(graph, input.first, input.last)
part2a_time = Time.now - start2a
puts "Part 2: #{part2a} (recursive, #{part2a_time}s)"

start2b = Time.now
hist = []
graph.reverse_each{ |k,v| v.each{ |i| hist[k] = (hist[k] || 0) + (hist[i] || 1) } }
part2b = hist.first
part2b_time = Time.now - start2b
puts "Part 2: #{part2b} (non-recursive, #{part2b_time}s, #{(part2a_time / part2b_time).round(2)}x faster)"

puts "Total:  #{Time.now - start}s"