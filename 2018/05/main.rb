data = File.read("input").chars.map(&:ord)

class Numeric
  def reacts_with?(other)
    (self - other).abs == 32
  end
end

def react(data)
  i = 0
  polymer = []
  loop do
    fst, nxt = data[i, 2]
    break if fst.nil?

    if polymer.last && polymer.last.reacts_with?(fst)
      polymer.pop
    elsif nxt && nxt.reacts_with?(fst)
      i += 1
    else
      polymer << fst
    end
    i += 1
  end
  polymer
end

part1 = react(data).size
puts "Part 1: #{part1}"

part2 = ('A'.ord..'Z'.ord).map{ |c| react( data.reject{ |d| d == c || d.reacts_with?(c) } ).size }.min
puts "Part 2: #{part2}"