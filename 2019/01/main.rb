data = File.readlines("input").map(&:to_i)

fuel_req = data.sum{ |mass| (mass / 3).floor - 2 }
puts "Part 1: #{fuel_req}"

fuel_req_2 = 0
while !data.empty?
  mass = data.shift
  fr = (mass / 3).floor - 2
  if fr > 0
    data << fr
    fuel_req_2 += fr
  end
end

puts "Part 2: #{fuel_req_2}"