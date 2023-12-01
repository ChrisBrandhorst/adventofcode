class String
  def is_int?
    self.to_i.to_s == self
  end
end

INT_MAP = {
  "one" => 1,
  "two" => 2,
  "three" => 3,
  "four" => 4,
  "five" => 5,
  "six" => 6,
  "seven" => 7,
  "eight" => 8,
  "nine" => 9
}

start = Time.now
input = File.read("input").split("\n").map(&:chars)
puts "Prep: #{Time.now - start}s"

start = Time.now
part1 = input.sum{ |i| (i.find{ _1.is_int? } + i.reverse.find{ _1.is_int? }).to_i }
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now

part2 = File.read("input").split("\n").sum do |l|

  done = false
  (0...l.size).each do |i|
    break if l[i].is_int? || done
    INT_MAP.each do |k,v|
      if l[i,k.length] == k
        l.sub!(k, v.to_s)
        done = true
        break
      end
    end
  end

  done = false
  (0...l.size).each do |i|
    break if l[l.length-i-1].is_int? || done
    INT_MAP.each do |k,v|
      if l[l.length-i-1,k.length] == k
        l = l.reverse.sub(k.reverse, v.to_s).reverse
        done = true
        break
      end
    end
  end
  
  cs = l.chars
  (cs.find{ _1.is_int? } + cs.reverse.find{ _1.is_int? }).to_i
end

puts "Part 2: #{part2} (#{Time.now - start}s)"