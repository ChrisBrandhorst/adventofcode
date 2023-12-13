start = Time.now
input = File.read("input").split("\n\n").map(&:split).map do |inp|
  grid = inp.map(&:chars)
  rows, cols = [0] * grid.size, [0] * grid.first.size
  grid.each_with_index do |row,y|
    row.each_with_index do |v,x|
      if v == "#"
        rows[y] += 2 ** x
        cols[x] += 2 ** y
      end
    end
  end
  [rows,cols]
end
puts "Prep: #{Time.now - start}s"


def get_mirror_line(arr, part1_i = nil)
  (1...arr.size).detect do |i|
    next if i == part1_i
    min_length = [i, arr.size - i].min
    arr[i-min_length...i].reverse.zip(arr[i,min_length]).all? do |a,b|
      d = a ^ b
      d == 0 || !part1_i.nil? && (d & (d - 1)) == 0
    end
  end
end


def get_mirror_lines(encoding, prev_lines = nil)
  rows, cols = encoding
  prmi, pcmi = prev_lines

  rmi = get_mirror_line(rows, prmi)
  cmi = get_mirror_line(cols, pcmi) if rmi.nil?

  [rmi || 0, cmi || 0]
end


start = Time.now
mirror_lines = input.map{ get_mirror_lines(_1) }
part1 = mirror_lines.sum{ _1 * 100 + _2 }
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = input.zip(mirror_lines).sum do |encoding,prev|
  nrmi, ncmi = get_mirror_lines(encoding, prev)
  nrmi * 100 + ncmi
end
puts "Part 2: #{part2} (#{Time.now - start}s)"