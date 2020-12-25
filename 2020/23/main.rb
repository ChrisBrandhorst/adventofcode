def game(circle, length = 100)
  do_prt = length > 100000
  cur, min, max = circle.first, circle.min, circle.max

  next_cups = circle.each_with_index.inject({}) do |nc,(l,i)|
    nc[l] = circle[i + 1] || circle[0]
    nc
  end

  length.times do |i|
    print "." if do_prt && i % 100000 == 0
    
    # Get picks
    a = next_cups[cur]
    b = next_cups[a]
    c = next_cups[b]

    # Find destination
    dst = cur - 1
    while dst < min || [a,b,c].include?(dst)
      dst = dst - 1 < min ? max : dst - 1
    end

    # Remove picks from circle
    next_cups[cur] = next_cups[c]

    # Add pick back to circle
    next_cups[c] = next_cups[dst]
    next_cups[dst] = a

    # Go next
    cur = next_cups[cur]
  end

  print " Done\n" if do_prt
  next_cups
end

def order(next_cups)
  (next_cups.count - 1).times.inject([1]){ |o| o << next_cups[o.last] }
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
part2 = result[1] * result[result[1]]
puts "Part 2: #{part2} (#{Time.now - start2}s)"

puts "Total:  #{Time.now - start}s"