start = Time.now
card_pk, door_pk = File.readlines("input").map{ |l| l.to_i }
puts "Prep:   #{Time.now - start}s"

def step(r, sub)
  r * sub % 20201227
end

def find_loop_size(sub, pk)
  0.step.inject(1){ |r,i| break i if r == pk; step(r, sub) }
end

def transform(sub, ls)
  ls.times.inject(1){ |r| step(r, sub) }
end

start1 = Time.now
part1 = transform(door_pk, find_loop_size(7, card_pk))
puts "Part 1: #{part1} (#{Time.now - start1}s)"

puts "Total:  #{Time.now - start}s"