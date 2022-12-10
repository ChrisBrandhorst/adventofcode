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
pixels = (0..cycle_value.size-2).map{ |i| (cycle_value[i] - (i % 40) ).abs > 1 ? "." : '#' }
puts pixels.each_slice(40).map(&:join)
part2 = nil
puts "Part 2: #{part2} (#{Time.now - start}s)"