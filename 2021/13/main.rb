require 'set'

start = Time.now
dots, folds = File.read("input", chomp: true).split("\n\n")
dots = Set.new( dots.split("\n").map{ |d| d.split(",").map(&:to_i) } )
folds = folds.split("\n").map{ |f| f.scan(/([xy])=(\d+)/).flatten }.map{ |f| [f.first, f.last.to_i] }
puts "Prep: #{Time.now - start}s"


def fold(dots, axis, point)
  dots.inject(Set.new) do |nd,d|
    x, y = d
    if axis == 'x' && x > point
      nd << [point * 2 - x, y]
    elsif axis == 'y' && y > point
      nd << [x, point * 2 - y]
    else
      nd << d
    end
    nd
  end
end


def inspect_dots(dots)
  dots.inject([]) do |pic,(x,y)|
    pic[y] ||= []
    pic[y][x] = "█"
    pic
  end.map{ |r| r.map{ |d| d || ' '}.join('') }.join("\n")
end


start = Time.now
part1 = fold(dots, *folds.first).size
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
puts inspect_dots( folds.inject(dots){ |d,f| fold(d, *f) } )
part2 = "☝️ "
puts "Part 2: #{part2} (#{Time.now - start}s)"