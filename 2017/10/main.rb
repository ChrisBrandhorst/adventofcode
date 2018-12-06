input = File.read("input")

list = (0..255).to_a
pos = 0
skip = 0

def get_list_values(list, pos, length)
  (pos..pos+length-1).map{ |i| list[i % list.size] }
end

def set_list_values(list, pos, values)
  (pos..pos+values.size-1).each{ |i| list[i % list.size] = values[i - pos] }
end

input.split(",").map(&:to_i).each do |i|
  values = get_list_values(list, pos, i)
  values.reverse!
  set_list_values(list, pos, values)
  pos += i + skip
  skip += 1
end

puts "Part 1: #{list[0] * list[1]}"


list2 = (0..255).to_a
pos = 0
skip = 0

seq = input.chars.map(&:ord) + [17, 31, 73, 47, 23]
64.times do |t|
  seq.each do |i|
    values = get_list_values(list2, pos, i)
    values.reverse!
    set_list_values(list2, pos, values)
    pos += i + skip
    skip += 1
  end
end

dense = (0..16-1).map{ |t| "%02x" % list2[16*t...16*(t+1)].inject(0){ |res,v| res = res ^ v } }.join
puts "Part 2: #{dense}"