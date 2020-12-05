require 'openssl'
input = File.readlines("input")

def pow(n, p, mod)
  n.to_bn.mod_exp(p, mod)
end

def inv(n, mod)
  pow(n, mod - 2, mod)
end

def single_shuffle(size, input)
  offset, increment = 0, 1
  input.each do |t|
    case t.chomp
    when /new/
      increment *= -1
      offset += increment
    when /increment (.*)/
      increment *= inv($1.to_i, size)
    when /cut (.*)/
      offset += increment * $1.to_i
    end
  end
  [offset % size, increment % size]
end

def multiple_shuffle(size, input, n)
  offset_diff, increment_mult = single_shuffle(size, input)
  [
    offset_diff * ( (1 - pow(increment_mult, n, size)) * inv(1 - increment_mult, size) ) % size,
    pow(increment_mult, n, size)
  ]
end

start = Time.now
deck_size = 10007
offset, increment = single_shuffle(deck_size, input)
part1 = (0..deck_size-1).detect{ |n| (offset + increment * n) % deck_size == 2019 }
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
deck_size = 119315717514047
offset, increment = multiple_shuffle(deck_size, input, 101741582076661)
part2 = (offset + increment * 2020) % deck_size
puts "Part 2: #{part2} (#{Time.now - start}s)"