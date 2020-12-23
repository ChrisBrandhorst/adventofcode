PRV = 0
NXT = 1

class Cup
  attr_reader :label
  attr_accessor :prv, :nxt

  def initialize(label)
    @label = label
  end

  def place_after(other)
    @prv = other
    other.nxt = self
  end
end

def game(circle, length = 100)
  do_prt = length > 100000
  min, max = circle.min, circle.max

  # Build hash of cups with neighbours
  cups = circle.each_with_index.inject({}) do |cups,(l,i)|
    pl = circle[i - 1]
    nl = circle[i + 1] || circle.first
    cup = cups[l] ||= Cup.new(l)
    cup.prv = cups[pl] ||= Cup.new(pl)
    cup.nxt = cups[nl] ||= Cup.new(nl)
    cups
  end

  cur = cups[circle.first]
  length.times do |i|
    print "." if do_prt && i % 100000 == 0

    # Get picks and labels
    pick_first, pick_last = cur.nxt, cur.nxt.nxt.nxt
    pick_labels = [
      pick_first.label,
      pick_first.nxt.label,
      pick_last.label
    ]

    # Find destination
    dst_label = cur.label - 1
    until dst_label >= min && !pick_labels.include?(dst_label)
      dst_label = dst_label - 1 < min ? max : dst_label - 1
    end
    dst = cups[dst_label]

    # Remove picks from circle
    pick_last.nxt.place_after(cur)

    # Add pick back to circle
    aft_dst = dst.nxt
    pick_first.place_after(dst)
    aft_dst.place_after(pick_last)

    # Go next
    cur = cur.nxt
  end

  print " Done\n" if do_prt
  cups
end

def order(cups)
  (cups.count-1).times.inject([ cups[1] ]){ |o| o << o.last.nxt }
end

start = Time.now
input = File.read("input").split('').map(&:to_i)
puts "Prep:   #{Time.now - start}s"

start1 = Time.now
result = game(input.dup)
part1 = order(result).drop(1).map(&:label).join('')
puts "Part 1: #{part1} (#{Time.now - start1}s)"

start2 = Time.now
circle = input.dup | (input.max+1..1000000).to_a
result = game(circle, 10000000)
n1 = result[1].nxt
part2 = n1.label * n1.nxt.label
puts "Part 2: #{part2} (#{Time.now - start2}s)"

puts "Total:  #{Time.now - start}s"