require_relative '../util/grid.rb'

class DumboOctopusCavern < Grid

  def initialize(rows)
    super(rows)
    @with_diag = true
  end

  def energize!(x, y = nil)
    x, y = *x if x.is_a?(Array)
    v = self[x, y]
    if v < 9
      self[x, y] = v + 1
      false
    else
      self[x, y] = 0
      true
    end
  end

end

start = Time.now
input = File.readlines("input", chomp: true).map{ |l| l.chars.map(&:to_i) }
cavern = DumboOctopusCavern.new(input)
puts "Prep: #{Time.now - start}s"


start = Time.now
part1, part2 = 0

1.step do |i|
  fc, q = 0, []

  cavern.each{ |c,v| q << c if cavern.energize!(c) }

  while e = q.shift
    fc += 1
    cavern.adj_coords(e).each{ |a| q << a if cavern[a] > 0 && cavern.energize!(a) }
  end

  part1 += fc if i <= 100
  part2 = i if cavern.flatten.sum == 0

  break if part1 && part2
end

puts "Part 1: #{part1}"
puts "Part 2: #{part2}"
puts "Part 1 & 2: #{Time.now - start}s"