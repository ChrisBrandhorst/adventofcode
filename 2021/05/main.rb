LINE_MATCHER = /(\d+),(\d+) -> (\d+),(\d+)/
XA = 0
XB = 2
YA = 1
YB = 3

def calc_overlapping_points(input, include_diagonals = false)
  diag = {}
  input = input.select{ |i| i[XA] == i[XB] || i[YA] == i[YB] } unless include_diagonals

  input.each do |i|

    xdiff, ydiff = i[XB] - i[XA], i[YB] - i[YA]
    xs, ys = xdiff == 0 ? 0 : xdiff / xdiff.abs, ydiff == 0 ? 0 : ydiff / ydiff.abs
    x, y = i[XA], i[YA]

    while true
      diag[y] ||= {}
      diag[y][x] ||= 0
      diag[y][x] += 1
      
      break if x == i[XB] && y == i[YB]
      x += xs
      y += ys
    end

  end

  diag.values.map{ |v| v.values.flatten }.flatten.count{ |v| v > 1 }
end


start = Time.now
input = File.readlines("input", chomp: true)
  .map{ |l| l.match(LINE_MATCHER).captures }
  .map{ |l| l.map(&:to_i) }

puts "Prep: #{Time.now - start}s"


start = Time.now
part1 = calc_overlapping_points(input)
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = calc_overlapping_points(input, true)
puts "Part 2: #{part2} (#{Time.now - start}s)"