start = Time.now
input = File.readlines("input", chomp: true).map(&:chars)

galaxies = (0...input.size).inject([]) do |g,y|
  g + (0...input[y].size).filter_map{ |x| [x,y] if input[y][x] == "#" }
end

@empty_cols_idx = input.transpose.each_with_index.filter_map{ |v,i| i if v.uniq.size == 1 }
@empty_rows_idx = input.each_with_index.filter_map{ |v,i| i if v.uniq.size == 1 }

puts "Prep: #{Time.now - start}s"


def expanded_distance(a, b, expander = 2)
  ax, ay = a
  bx, by = b

  col_exp = @empty_cols_idx.count{ _1 >= [bx,ax].min && _1 <= [bx,ax].max }
  row_exp = @empty_rows_idx.count{ _1 >= [by,ay].min && _1 <= [by,ay].max }

  (bx-ax).abs + (by-ay).abs + (col_exp + row_exp) * (expander - 1)
end


start = Time.now
part1 = galaxies.combination(2).sum{ |a,b| expanded_distance(a,b) }
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = galaxies.combination(2).sum{ |a,b| expanded_distance(a,b,1000000) }
puts "Part 2: #{part2} (#{Time.now - start}s)"