Claim = Struct.new(:id, :x, :y, :width, :height, :overlap)
CLAIM_FORMAT = /^#(\d+) \@ (\d+),(\d+): (\d+)x(\d+)/

data = File.readlines("input").map{ |c| c.match(CLAIM_FORMAT){ |m| Claim.new(*m.captures.map(&:to_i) ) } }

fabric = []
data.each do |d|
  (d.x...d.x+d.width).each do |a|
    (d.y...d.y+d.height).each do |b|
      fabric[a] ||= []
      fabric[a][b] ||= []
      fabric[a][b] << d
      fabric[a][b].each{ |c| c.overlap = true } if fabric[a][b].size > 1
    end
  end
end

one = fabric.flatten(1).count{ |i| !i.nil? && i.size > 1 }
puts "Part 1: #{one}"

two = fabric.flatten.select{ |c| !c.nil? && !c.overlap }.first.id
puts "Part 2: #{two}"