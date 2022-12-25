start = Time.now
input = File.readlines("input", chomp: true)
  .map(&:chars)

SNAFU = { "=" => -2, "-" => -1 }
puts "Prep: #{Time.now - start}s"

def snafu_to_dec(snafu)
  snafu.map.with_index.sum{ _1 * 5 ** _2 }
end

start = Time.now

dec = input.sum{ |l| snafu_to_dec( l.map{ SNAFU[_1] || _1.to_i }.reverse ) }

h = 0; h += 1 until 5 ** h > dec
snafu = [2] * h
rd = snafu_to_dec(snafu)

(0...h).to_a.reverse.each do |i|
  s = 5 ** i
  while rd - s >= dec
    rd -= s
    snafu[h-i-1] -= 1
  end
end

part1 = snafu.map{ SNAFU.invert[_1] || _1 }.join
puts "Part 1: #{part1} (#{Time.now - start}s)"