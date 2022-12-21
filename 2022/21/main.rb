require 'bigdecimal'

start = Time.now
input = File.readlines("input", chomp: true)
  .map{ _1.match(/^(\w+): ((\d+)|(\w+) (.) (\w+))$/).captures }
  .to_h{ |l| [l[0].to_sym, l[2] ? BigDecimal(l[2]) : l[3..5].map(&:to_sym)] }
puts "Prep: #{Time.now - start}s"

def calc(input, humn = nil)
  todo = input.keys
  vals = {}
  vals[:humn] = humn unless humn.nil?

  until todo.empty?
    k = todo.shift
    if vals.key?(k)
      next
    elsif input[k].is_a?(Numeric)
      vals[k] = input[k]
    elsif vals.key?(input[k][0]) && vals.key?(input[k][2])
      if k == :root
        return [vals[input[k][0]], vals[input[k][2]]]
      else
        vals[k] = vals[input[k][0]].send( input[k][1], vals[input[k][2]] )
      end
    else
      todo << k
    end

  end
end


start = Time.now
part1 = (part1_sol = calc(input)).sum.to_i
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now

x1, y1 = input[:humn], part1_sol[0]
x2, y2 = input[:humn] += 1, calc(input)[0]

d = (part1_sol[1] - y2)
dx = (x2 - x1)
dy = (y2 - y1)

part2 = (d / dy * dx + x2).round
puts "Part 2: #{part2} (#{Time.now - start}s)"