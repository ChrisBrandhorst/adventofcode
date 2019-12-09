input = File.read("input").split("").map(&:to_i)

WIDTH = 25
HEIGHT = 6

start = Time.now
layers = input.each_slice(WIDTH * HEIGHT).to_a
checksum_layer = layers.sort_by{ |l| l.select{ |p| p == 0 }.count }.first
part1 = checksum_layer.select{ |p| p == 1 }.count * checksum_layer.select{ |p| p == 2 }.count
puts "Part 1: #{part1} (#{Time.now - start}s)"

BLACK = 0
WHITE = 1
TRANS = 2

start = Time.now
image = []
layers.each do |l|
  l.each_with_index do |p,i|
    image[i] ||= (p == WHITE ? '█' : " ") unless p == TRANS
  end
end

render = image.each_slice(WIDTH).to_a.map(&:join).join("\n")
puts "Part 2: (#{Time.now - start}s)"
puts render