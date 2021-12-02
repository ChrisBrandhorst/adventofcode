start = Time.now
input = File.readlines("input", chomp: true)
  .map{ |l|
    i = l.split(' ')
    i[1] = i[1].to_i
    i
  }
puts "Prep: #{Time.now - start}s"


def calc(inp, part2 = false)
  pos, b, c = 0, 0, 0
  inp.each do |op,x|
    case op
    when 'forward'
      pos += x
      c += b * x
    when 'down'
      b += x
    when 'up'
      b -= x
    end
  end
  pos * (part2 ? c : b)
end

start = Time.now
part1 = calc(input)
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = calc(input, true)
puts "Part 2: #{part2} (#{Time.now - start}s)"