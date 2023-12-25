start = Time.now
input = File.readlines("input", chomp: true).inject([]) do |r,l|
  from, to = l.split(": ")
  to.split(" ").each{ r << [from,_1] }
  r
end
puts "Prep: #{Time.now - start}s"


class Karger

  def initialize(edges)
    @edges = edges
    @vertices = edges.flatten.uniq
  end
  
  def mincut
    @parent, @rank = {}, {}
    @vertices.each do |v|
      @parent[v] = v
      @rank[v] = 0
    end

    vertices = @vertices.size
    while vertices > 2
      i = rand(@edges.size)
      edge = @edges[i]
      set1, set2 = find(edge.first), find(edge.last)

      if set1 != set2
        union(edge.first, edge.last)
        vertices -= 1
      end
    end

    (0...@edges.size).inject(0) do |a,i|
      edge = @edges[i]
      set1, set2 = find(edge.first), find(edge.last)
      set1 != set2 ? a + 1 : a
    end

  end

  def union(u,v)
    u, v = find(u), find(v)
    if (u != v)
      u, v = v, u if @rank[u] < @rank[v]
      @parent[v] = u
      @rank[u] += 1 if @rank[u] == @rank[v]
    end
  end
 
  def find(node)
    node == @parent[node] ? node : @parent[node] = find(@parent[node])
  end

  def get_cut_sets
    @parent.inject({}){ |r,(k,v)| (r[v] ||= []) << k; r }.values
  end

end


start = Time.now
karger = Karger.new(input)
until karger.mincut == 3; end
part1 = karger.get_cut_sets.map(&:size).inject(&:*)
puts "Part 1: #{part1} (#{Time.now - start}s)"