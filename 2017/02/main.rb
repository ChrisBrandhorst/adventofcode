data = File.readlines("input").map{ |r| r.split("\t").map(&:to_i) }

checksum = data.map{ |r| r.max - r.min }.sum
puts "Part 1: #{checksum}"

b = nil
sum = data.sum do |r|
  r.find do |d|
    b = r.find { |d2| d > d2 && d % d2 == 0 }
  end / b
end
puts "Part 2: #{sum}"