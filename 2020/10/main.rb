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

start2 = Time.now
graph = input.each_with_index.inject({}){ |g,(a,i)| g[a] = input[i+1,3].select{ |b| b - a <= 3 }; g }
part2 = get_path_count(graph, input.first, input.last)
puts "Part 2: #{part2} (#{Time.now - start2}s)"

puts "Total:  #{Time.now - start}s"