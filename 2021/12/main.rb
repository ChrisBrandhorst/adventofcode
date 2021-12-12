START_NODE = 'start'
END_NODE = 'end'

start = Time.now
input = File.readlines("input", chomp: true).map{ |l| l.split('-') }

nodes = input.inject({}) do |n,(a,b)|
  if a != END_NODE
    n[a] ||= []
    n[a] << b
  end
  if a != START_NODE
    n[b] ||= []
    n[b] << a
  end
  n
end

puts "Prep: #{Time.now - start}s"


def bfg(nodes, double = nil)
  paths = []
  q = [[START_NODE]]
  while path = q.shift
    if path.last == END_NODE
      paths << path
    else
      nodes[path.last].each do |alt|
        is_possible = !path.include?(alt) || alt == alt.upcase || alt == double && path.count(alt) < 2
        q << path + [alt] if is_possible
      end
    end
  end
  paths
end


start = Time.now
part1 = bfg(nodes).size
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = nodes.keys.select{ |k| k != START_NODE && k.downcase == k }.map{ |c| bfg(nodes, c) }.flatten(1).uniq.size
puts "Part 2: #{part2} (#{Time.now - start}s)"