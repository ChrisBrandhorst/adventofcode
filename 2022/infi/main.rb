start = Time.now
input = File.readlines("input", chomp: true)
  .map{ a = _1.split(" "); [a[0], a[1].to_i] }
puts "Prep: #{Time.now - start}s"

start = Time.now

pos = [0,0]
dir = 0
word = {}

input.each do |o,v|

  case o
  when 'draai'
    dir = (dir + v) % 360
  else
    d = o == 'loop' ? 1 : v
    (o == 'loop' ? v : 1).times do
      case dir
      when 0
        pos[1] += d
      when 45
        pos[0] += d
        pos[1] += d
      when 90
        pos[0] += d
      when 135
        pos[0] += d
        pos[1] -= d
      when 180
        pos[1] -= d
      when 225
        pos[0] -= d
        pos[1] -= d
      when 270
        pos[0] -= d
      when 315
        pos[0] -= d
        pos[1] += d
      end
      word[pos.dup] = '#'
    end

  end

end

part1 = pos[0].abs + pos[1].abs
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
min_x, max_x = word.keys.map{ _1.first }.minmax
min_y, max_y = word.keys.map{ _1.last }.minmax
puts (min_y..max_y).map{ |y| (min_x..max_x).map{ |x| word[[x,y]] || " " }.join }.reverse.join("\n")
part2 = nil
puts "Part 2: #{part2} (#{Time.now - start}s)"