WHITE = 0
BLACK = 1

start = Time.now
input = File.readlines("input", chomp: true).map{ |l| l.gsub(/(e|se|sw|w|nw|ne)(?!,)/, '\1,\2').split(',') }
tiles = {[0,0] => WHITE }
puts "Prep:   #{Time.now - start}s"

start1 = Time.now

input.each do |l|
  x, y = 0, 0

  l.each do |s|
    case s
    when 'e'
      x += 1
    when 'se'
      x += 1
      y -= 1
    when 'sw'
      y -= 1
    when 'w'
      x -= 1
    when 'nw'
      x -= 1
      y += 1
    when 'ne'
      y += 1
    end
  end

  c = [x,y]
  tiles[c] = tiles[c] ? 1 - tiles[c] : BLACK
end

part1 = tiles.values.flatten.count(BLACK)
puts "Part 1: #{part1} (#{Time.now - start1}s)"


def neighbours(tiles, x, y)
  [
    [x + 1, y    ],
    [x + 1, y - 1],
    [x,     y - 1],
    [x - 1, y    ],
    [x - 1, y + 1],
    [x,     y + 1]
  ].inject({}){ |n, c| n[c] = tiles[c] || WHITE; n }
end


start2 = Time.now

100.times do |i|

  all_ns = {}
  all_adj = tiles.inject({}) do |aa,(c,t)|
    aa[c] = t
    ns = neighbours(tiles, *c)
    all_ns[c] = ns
    aa.merge!( ns )
  end

  to_flip = {}
  all_adj.each do |c,t|
    blacks = (all_ns[c] || neighbours(tiles, *c)).values.count(BLACK)

    if t == BLACK && (blacks == 0 || blacks > 2)
      to_flip[c] = WHITE
    elsif t == WHITE && blacks == 2
      to_flip[c] = BLACK
    end
  end

  to_flip.each do |c,t|
    tiles[c] = t
  end

  print "."
end
puts "Done"

part2 = tiles.values.flatten.count(BLACK)
puts "Part 2: #{part2} (#{Time.now - start2}s)"

puts "Total:  #{Time.now - start}s"