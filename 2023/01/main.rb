class String
  def is_int?
    self.to_i.to_s == self
  end
end

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
MIN_INT_LENGTH = INT_MAP.keys.map(&:length).min

start = Time.now
input = File.read("input").split("\n").map(&:chars)
puts "Prep: #{Time.now - start}s"

start = Time.now
part1 = input.sum{ |i| (i.find{ _1.is_int? } + i.reverse.find{ _1.is_int? }).to_i }
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now

part2 = File.read("input").split("\n").sum do |l|

  first, last = nil

  (0...l.size).each do |i|
    first = l[i]            if first.nil? && l[i].is_int?
    last  = l[l.length-i-1] if last.nil?  && l[l.length-i-1].is_int?
    
    INT_MAP.each do |k,v|
      first = v if first.nil? && l[i,k.length] == k
      last  = v if last.nil?  && l[l.length-i-1,k.length] == k
    end
    break if first && last
  end

  (first + last).to_i
end

puts "Part 2: #{part2} (#{Time.now - start}s)"