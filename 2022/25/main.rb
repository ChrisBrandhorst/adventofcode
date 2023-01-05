start = Time.now
input = File.readlines("input", chomp: true)
  .map(&:chars)

SNAFU = { "=" => -2, "-" => -1 }
puts "Prep: #{Time.now - start}s"

def snafu_to_dec(snafu)
  snafu.map.with_index.sum{ SNAFU.fetch(_1, _1.to_i) * 5 ** _2 }
end

start = Time.now
dec = input.sum{ snafu_to_dec(_1.reverse) }

h = Math.log(dec, 5).ceil
snafu = [2] * h
rd = snafu_to_dec(snafu)

(h-1).downto(0) do |i|
  s = 5 ** i
  l = (rd - dec) / s
  next if l <= 0
  rd -= s * l
  snafu[h-i-1] -= l
end

part1 = snafu.map{ SNAFU.key(_1) || _1 }.join
puts "Part 1: #{part1} (#{Time.now - start}s)"