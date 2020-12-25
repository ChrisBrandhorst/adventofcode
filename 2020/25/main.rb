start = Time.now
card_pk, door_pk = File.readlines("input").map{ |l| l.to_i }
puts "Prep:   #{Time.now - start}s"

def step(res, sub)
  res * sub % 20201227
end

def find_loop_size(sub, pk)
  res = 1
  1.step do |ls|
    res = step(res, sub)
    return ls if res == pk
  end
end

def transform(sub, ls)
  ls.times.inject(1){ |r| r = step(r, sub) }
end

start1 = Time.now
part1 = transform(door_pk, find_loop_size(7, card_pk))
puts "Part 1: #{part1} (#{Time.now - start1}s)"

puts "Total:  #{Time.now - start}s"