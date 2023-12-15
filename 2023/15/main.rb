start = Time.now
input = File.read("input", chomp: true).split(",")
puts "Prep: #{Time.now - start}s"


def hash(s)
  s.each_byte.inject(0){ |h,c| (h + c) * 17 % 256 }
end

start = Time.now
part1 = input.sum{ hash(_1) }
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now

boxes = input.inject({}) do |bxs,s|
  label, focal = s.split(/[=-]/)
  box = (bxs[hash(label)] ||= [])
  pos = box.index{ |l,f| l == label }

  if focal.nil?
    box.delete_at(pos) if pos
  else
    if pos
      box[pos][1] = focal
    else
      box << [label,focal]
    end
  end
  bxs
end

part2 = boxes.sum{ |i,box| box.each_with_index.sum{ |(l,f),j| (i+1) * (j+1) * f.to_i } }
puts "Part 2: #{part2} (#{Time.now - start}s)"