input = File.readlines("input").map do |i|
  i =~ /\d+ <-> ([\d,\s]+)$/
  eval("[#{$1}]")
end


def collect_connected(input, cur, connected)
  nxt = input[cur] - connected
  connected.push(*nxt).uniq!
  nxt.each{ |n| collect_connected(input, n, connected) }
end

def get_connected(input, program)
  connected = []
  collect_connected(input, program, connected)
  connected
end
puts "Part 1: #{get_connected(input, 0).size}"


groups = []
input.each_with_index { |e,i| groups << get_connected(input, i).sort }
puts "Part 2: #{groups.uniq.size}