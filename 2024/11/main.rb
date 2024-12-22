require_relative '../util/time'

def prep
  File.read("input", chomp: true).split.map(&:to_i).tally
end

def calc(stones, rep)
  rep.times do |i|
    ns = Hash.new(0)
    stones.each do |n,c|
      if n == 0
        ns[1] += c
      else
        nod = Math.log10(n).to_i + 1
        if nod.even?
          pwr = 10 ** (nod / 2)
          ns[n / pwr] += c
          ns[n % pwr] += c
        else
          ns[n * 2024] += c
        end
      end
    end
    stones = ns
  end

  stones.values.sum
end

input = time("Prep", false){ prep }
time("Part 1"){ calc(input, 25) }
time("Part 2"){ calc(input, 75) }