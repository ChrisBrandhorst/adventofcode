start = Time.now
input = File.readlines("input", chomp: true)
  .map{ _1.scan(/(toggle|on|off) (\d+),(\d+) through (\d+),(\d+)/).first }
  .map{ |o,a,b,c,d| [o.to_sym, a.to_i, b.to_i, c.to_i, d.to_i] }
puts "Prep: #{Time.now - start}s"


start = Time.now

lights = {}
input.each do |o|
  (o[1]..o[3]).each do |x|
    (o[2]..o[4]).each do |y|
      c = [x,y]
      lights[c] = case o[0]
      when :on;     true
      when :off;    false
      when :toggle; !lights[c]
      end
    end
  end
end

part1 = lights.count{ _2 == true }
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now

lights = {}
input.each do |o|
  (o[1]..o[3]).each do |x|
    (o[2]..o[4]).each do |y|
      c = [x,y]
      b = lights[c].to_i + case o[0]
      when :on;     1
      when :off;    -1
      when :toggle; 2
      end
      lights[c] = b < 0 ? 0 : b
    end
  end
end

part2 = lights.values.sum
puts "Part 2: #{part2} (#{Time.now - start}s)"