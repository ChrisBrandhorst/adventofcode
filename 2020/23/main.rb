PRV = 0
NXT = 1

def game(circle, length = 100)
  prt = length > 100000
  min = circle.min
  max = circle.max

  h = circle.each_with_index.inject({}) do |h,(l,i)|
    h[l] = [
      circle[i - 1],
      circle[i + 1] || circle.first
    ]; h
  end

  cur = circle.first
  length.times do |i|
    print "." if prt && i % 100000 == 0

    nxt = [
      h[cur][NXT],
      h[h[cur][NXT]][NXT],
      h[h[h[cur][NXT]][NXT]][NXT]
    ]

    dst = cur - 1
    until dst >= min && !nxt.include?(dst)
      dst -= 1
      dst = max if dst < min
    end

    cur_nxt = h[nxt[2]][NXT]
    aft = h[dst][NXT]

    # Remove nxt from circle
    h[cur][NXT] = cur_nxt
    h[cur_nxt][PRV] = cur

    # Add nxt back to circle
    h[dst][NXT] = nxt[0]
    h[aft][PRV] = nxt[2]

    h[nxt[0]][PRV] = dst
    h[nxt[2]][NXT] = aft

    cur = h[cur][NXT]
  end

  print " Done\n" if prt
  h
end

def order(h)
  (h.count-1).times.inject([1]){ |o| o << h[o.last][NXT] }
end

start = Time.now
input = File.read("input").split('').map(&:to_i)
puts "Prep:   #{Time.now - start}s"

start1 = Time.now
result = game(input.dup)
part1 = order(result).drop(1).join('')
puts "Part 1: #{part1} (#{Time.now - start1}s)"

start2 = Time.now
circle = input.dup | (input.max+1..1000000).to_a
result = game(circle, 10000000)
n1 = result[1][NXT]
part2 = n1 * result[n1][NXT]
puts "Part 2: #{part2} (#{Time.now - start2}s)"

puts "Total:  #{Time.now - start}s"















