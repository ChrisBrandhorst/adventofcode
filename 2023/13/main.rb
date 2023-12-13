require '../util/grid'


start = Time.now
input = File.readlines("input", chomp: true)
patterns = input.inject([[]]) do |ps,l|
  if l == ""
    ps << []
  else
    ps.last << l
  end
  ps
end
patterns = patterns.map{ Grid.new(_1.map(&:chars)) }
puts "Prep: #{Time.now - start}s"


def get_mirror_lines(pattern, flip = nil, prmi = nil, pcmi = nil)
  rows, cols = [0] * pattern.row_count, [0] * pattern.col_count
  old_v = nil

  if flip
    old_v = pattern[flip]
    pattern[flip] = old_v == "#" ? "." : "#"
  end

  pattern.each do |(x,y),v|
    if v == "#"
      rows[y] += 2 ** x
      cols[x] += 2 ** y
    end
  end

  pattern[flip] = old_v if flip

  rmi = (1...rows.size).detect do |i|
    next if i == prmi
    min_length = [i, rows.size - i].min
    rows[i-min_length...i].reverse == rows[i,min_length]
  end
  
  if rmi.nil?
    cmi = (1...cols.size).detect do |i|
      next if i == pcmi
      min_length = [i, cols.size - i].min
      cols[i-min_length...i].reverse == cols[i,min_length]
    end
  end

  [rmi || 0, cmi || 0]
end



start = Time.now
pattern_mirrors = patterns.map{ get_mirror_lines(_1) }
part1 = pattern_mirrors.sum{ _1 * 100 + _2 }
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = patterns.each_with_index.sum do |pattern,i|
  pattern.each do |(x,y),v|
    nrmi, ncmi = get_mirror_lines(pattern, [x,y], *pattern_mirrors[i])
    break(nrmi * 100 + ncmi) if nrmi > 0 || ncmi > 0
  end
end
puts "Part 2: #{part2} (#{Time.now - start}s)"