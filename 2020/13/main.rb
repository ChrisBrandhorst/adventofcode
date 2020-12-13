require 'openssl'

def pow(n, p, mod)
  n.to_bn.mod_exp(p, mod)
end

def inv(n, mod)
  pow(n, mod - 2, mod)
end

# Find t such that
# for each bus
# t ≡ Ib (mod Mb)
# Where Ib = Bus offset (remainder)
# ANd Mb = Bus ID
# https://crypto.stanford.edu/pbc/notes/numbertheory/crt.html
def chin_rem(moduli, remainders)
  prod = moduli.inject(:*)
  remainders
    .zip(moduli)
    .map{ |a,m| (a * prod / m) * inv(prod / m, m) }
    .inject(:+) % prod
end

start = Time.now
input = File.readlines("input")
time = input.first.to_i
lines = input.last.split(',').map{ |l| l == 'x' ? nil : l.to_i }
puts "Prep:   #{Time.now - start}s"

start1 = Time.now
min_time = lines.compact.map{ |l| [l, (time.to_f / l).ceil * l] }.min{ |a,b| a.last <=> b.last }
part1 = (min_time.last - time) * min_time.first
puts "Part 1: #{part1} (#{Time.now - start1}s)"

start2 = Time.now
ids, offsets = [], []
lines.each_with_index do |l,i|
  next if l.nil?
  ids << l
  offsets << -i
end
part2 = chin_rem(ids, offsets)

puts "Part 2: #{part2} (#{Time.now - start2}s)"

puts "Total:  #{Time.now - start}s"