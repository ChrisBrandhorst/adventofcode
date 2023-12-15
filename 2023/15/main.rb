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

boxes = []
input.each do |s|
  label, focal = s.split(/[=-]/)
  box = (boxes[hash(label)] ||= [])
  
  if focal.nil?
    box.delete_if{ |l,f| l == label }
  else
    focal = focal.to_i
    if existing = box.detect{ |l,f| l == label }
      existing[1] = focal
    else
      box << [label,focal]
    end
  end
end

part2 = boxes.each_with_index.sum do |box,i|
  (box || []).each_with_index.sum{ |(l,f),j| (i+1) * (j+1) * f }
end
puts "Part 2: #{part2} (#{Time.now - start}s)"