INT_MAP = {
  "one" => "1",
  "two" => "2",
  "three" => "3",
  "four" => "4",
  "five" => "5",
  "six" => "6",
  "seven" => "7",
  "eight" => "8",
  "nine" => "9"
}

class String
  def is_int?
    self.to_i.to_s == self
  end

  def get_int_at(i)
    c = self[i]
    c.is_int? ? c : ((s = INT_MAP.find{ |k,v| self[i,k.size] == k }) ? s.last : nil)
  end

  def get_all_ints
    (0...self.size).inject([]){ |r,i| r << self.get_int_at(i); r }.compact
  end
end


start = Time.now
input = File.readlines("input")
puts "Prep: #{Time.now - start}s"


start = Time.now
part1 = input.sum{ _1.chars.select(&:is_int?).values_at(0,-1).join.to_i }
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = input.sum{ _1.get_all_ints.values_at(0,-1).join.to_i }
puts "Part 2: #{part2} (#{Time.now - start}s)"


start = Time.now
part2 = input.sum do |l|
  first, last = nil
  (0...l.size).each do |i|
    first ||= l.get_int_at(i)
    last ||= l.get_int_at(l.size-i-1)
    break if first && last
  end
  (first + last).to_i
end
puts "Part 2: #{part2} (#{Time.now - start}s)"