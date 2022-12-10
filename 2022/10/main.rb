start = Time.now
input = File.readlines("input", chomp: true)
  .map(&:split)
  .map{ [_1, _2.to_i] }

cycle_value = input.inject([1]) do |cv,(o,v)|
  cv << cv.last
  cv << cv.last + v if o == "addx"
  cv
end
puts "Prep: #{Time.now - start}s"

start = Time.now
part1 = [20,60,100,140,180,220].sum{ |c| c * cycle_value[c-1] }
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
image = cycle_value[0..-2].each_with_index.inject("") do |im, (v,i)|
  im += ((v - (i % 40) ).abs > 1 ? "." : '#')
  (i + 1) % 40 == 0 ? im + "\n" : im
end
puts image
part2 = nil
puts "Part 2: #{part2} (#{Time.now - start}s)"