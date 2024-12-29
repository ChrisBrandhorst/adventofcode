start = Time.now
input = File.readlines("input", chomp: true).map{ r = _1.scan(/(\w+) to (\w+) = (\d+)/).first; r[2] = r[2].to_i; r }
distances = input.inject({}) do |r,(a,b,d)|
  (r[a] ||= {})[b] = (r[b] ||= {})[a] = d
  r
end
puts "Prep: #{Time.now - start}s"


def search(node, path, distances, res = [])
  path << node
  return res << path if path.size == distances.keys.size

  distances[node].each do |c,d|
    next if path.include?(c)
    search(c, path.clone, distances, res)
  end

  res
end


start = Time.now
routes = distances.keys
  .inject([]){ _1 + search(_2, [], distances) }
  .map{ _1.each_cons(2).sum{ |a,b| distances[a][b] } }
part1 = routes.min
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = routes.max
puts "Part 2: #{part2} (#{Time.now - start}s)"