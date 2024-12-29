start = Time.now
input = File.readlines("input", chomp: true).inject({}) do |r,l|
  ingr, props = l.split(": ")
  r[ingr] = props.split(", ").map{ a = _1.split; [a.first, a.last.to_i] }.to_h
  r
end
PROPERTIES = input.values.first.keys
ROOM = 100
puts "Prep: #{Time.now - start}s"


start = Time.now

scores = []
(0..ROOM).each do |a|
  (0..ROOM).each do |b|
    (0..ROOM).each do |c|
      d = ROOM - a - b - c
      score = PROPERTIES[0...4].map do |pr|
        [
          0,
          a * input.values[0][pr] +
          b * input.values[1][pr] +
          c * input.values[2][pr] +
          d * input.values[3][pr]
        ].max
      end.inject(&:*)
      scores << score
    end
  end
end

part1 = scores.max
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now

scores = []
(0..ROOM).each do |a|
  (0..ROOM).each do |b|
    (0..ROOM).each do |c|
      d = ROOM - a - b - c
      next unless [a,b,c,d].each_with_index.sum{ _1 * input.values[_2]["calories"] } == 500
      score = PROPERTIES[0...4].map do |pr|
        [
          0,
          a * input.values[0][pr] +
          b * input.values[1][pr] +
          c * input.values[2][pr] +
          d * input.values[3][pr]
        ].max
      end.inject(&:*)
      scores << score
    end
  end
end

part2 = scores.max
puts "Part 2: #{part2} (#{Time.now - start}s)"