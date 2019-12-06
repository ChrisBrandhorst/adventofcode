require 'set'

def dijkstra(graph, source)

  dist = {}
  prev = {}
  q = Set[]

  graph.each do |v|
    dist[v] = Float::INFINITY
    prev[v] = nil
    q << v
  end
  dist[source] = 0
  
  while !q.empty?
    u = find_min_dist(dist, q)
    q.delete(u)
    
    u.neighbours.each do |v|
      alt = dist[u] + u.distance_to(v)
      if alt < dist[v]
        dist[v] = alt
        prev[v] = u
      end
    end
  end

  [dist, prev]
end

def dijkstra_shortest_path(graph, source, target)
  dist, prev = dijkstra(graph, source)
  s = []
  u = target
  if !prev[u].nil? || u == source
    while !u.nil?
      s.unshift(u)
      u = prev[u]
    end
  end
  s
end

def find_min_dist(dist, q)
  q.sort_by{ |u| dist[u] }.first
end