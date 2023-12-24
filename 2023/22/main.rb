require 'set'

start = Time.now

space, supports, is_supported_by = {}, {}, {}

input = File.readlines("input", chomp: true).each_with_index.inject({}) do |r,(l,i)|
  ends = l.split("~").map{ |c| c.split(",").map(&:to_i) }
  daxis = (0..2).map{ |i| ends[1][i] - ends[0][i] }
  axis = daxis.index{ _1 > 0 }
  r[i] = coords = axis.nil? ? [ends.first] : (0..daxis.max).map{ |i| c = ends[0].clone; c[axis] += i; c }
  coords.each{ space[_1] = i}
  r
end

input.sort{ |(_,a),(_,b)| a.map{_1[2]}.min <=> b.map{_1[2]}.min }.each do |bi, b|
  down = b
  1.step do |i|
    new_down = b.map{ [_1[0],_1[1],_1[2]-i] }
    if new_down.all?{ space[_1].nil? || space[_1] == bi } && !new_down.any?{ _1[2] == 0 }
      down = new_down
      next
    else
      sup = new_down.map{ space[_1] }.compact.uniq
      sup.delete(bi)

      b.each do |c|
        space.delete(c)
        c[2] -= i - 1
        space[c] = bi
      end

      is_supported_by[bi] = sup
      supports[bi] ||= []
      sup.each{ (supports[_1] ||= []) << bi }
      break
    end
  end
end

puts "Prep: #{Time.now - start}s"


start = Time.now
part1 = supports.values.count{ |s| s.all?{ is_supported_by[_1].size > 1 } }
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = input.inject(0) do |d,(bi,b)|
  fallen = Set.new
  could_fall = supports[bi].clone
  until could_fall.empty?
    poss = could_fall.shift
    if is_supported_by[poss].all?{ fallen.include?(_1) || _1 == bi }
      fallen << poss
      could_fall += supports[poss]
    end
  end
  d + fallen.size
end
puts "Part 2: #{part2} (#{Time.now - start}s)"