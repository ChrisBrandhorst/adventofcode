input = File.readlines("input").map(&:to_i)

start = Time.now
fuel_req = input.sum{ |mass| (mass / 3).floor - 2 }
puts "Part 1: #{fuel_req} (#{Time.now - start}s)"

start = Time.now
fuel_req_2 = 0
reqs = input.clone
while !reqs.empty?
  mass = reqs.shift
  fr = (mass / 3).floor - 2
  if fr > 0
    reqs << fr
    fuel_req_2 += fr
  end
end
puts "Part 2: #{fuel_req_2} (#{Time.now - start}s)"