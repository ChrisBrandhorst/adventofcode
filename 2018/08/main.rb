class Node

  attr_reader :nodes
  attr_accessor :meta
  def initialize
    @nodes = []
    @meta = []
  end

  def <<(node)
    @nodes << node
  end

  def branch
    [self] + descendants
  end

  def descendants
    @nodes.map{ |n| [n] + n.descendants}.flatten
  end

  def value
    if @nodes.any?
      @meta.map{ |m| n = @nodes[m - 1]; n ? n.value : 0 }.sum
    else
      @meta.sum
    end
  end

end

data = File.read("input").split(' ').map(&:to_i)

def get_node(i, data)
  node = Node.new

  child_count = data[i]; i += 1
  meta_count = data[i]; i += 1

  child_count.times do |c|
    child_node, i = get_node(i, data)
    node << child_node
  end

  node.meta = data[i...i + meta_count]
  [node, i + meta_count]
end

root, i = get_node(0, data)
part1 = root.branch.map(&:meta).flatten.sum
puts "Part 1: #{part1}"
puts "Part 2: #{root.value}"