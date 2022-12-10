require 'set'
require 'matrix'

start = Time.now
input = File.readlines("input", chomp: true)
  .map{ _1.split(' ') }
 .map{ |(d,v)| [d, v.to_i] }
puts "Prep: #{Time.now - start}s"

def simulate(knots, input)
  tail_visited = Set.new
  
  input.each do |(d,v)|
    v.times do |t|

      head = knots[0]

      if d == "R"
        head[0] += 1
      elsif d == "L"
        # head[0] -= 1 # Doet niet 🤷‍♀️
        knots[0] = [head[0] - 1, head[1]]
      elsif d == "D"
        head[1] -= 1
      elsif d == "U"
        head[1] += 1
      end

      (0...knots.size-1).each do |i|
        h, t = knots[i], knots[i+1]
        d_x, d_y = h.first - t.first, h.last - t.last

        next if d_x.abs <= 1 && d_y.abs <= 1

        t = [t.first + d_x, t.last + d_y]
        # t[0] = t[0] + d_x
        # t[1] = t[1] + d_y

        t[0] -= d_x / d_x.abs if d_x.abs > 1
        t[1] -= d_y / d_y.abs if d_y.abs > 1

        knots[i+1] = t

      end
      tail_visited << knots.last
    end

  end
  tail_visited.size
end

def vis(knots)
  (0...21).to_a.reverse.map do |y|
    (0...26).map{ |x| knots.find_index([x,y]) || "." }.join
  end.join("\n") + "\n\n"
end

start = Time.now
knots = [[0,0]] * 2
part1 = simulate(knots, input)
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
# knots = [[11,5]] * 10
knots = [[0,0]] * 10
part2 = simulate(knots, input)
puts "Part 2: #{part2} (#{Time.now - start}s)"