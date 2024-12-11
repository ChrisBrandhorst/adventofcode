require_relative '../util/time'

def prep
  File.read("input", chomp: true).split.map(&:to_i).tally
end

class Hash
  def increase(k, v)
    self[k] ||= 0
    self[k] += v
  end
end

def calc(stones, rep)
  rep.times do |i|
    stones = stones.inject({}) do |ns,(n,c)|
      if n == 0
        ns.increase(1, c)
      else
        nod = Math.log10(n).to_i + 1
        if nod.even?
          pwr = 10 ** (nod / 2)
          ns.increase(n / pwr, c)
          ns.increase(n % pwr, c)
        else
          ns.increase(n * 2024, c)
        end
      end
      ns
    end
  end

  stones.values.sum
end

input = time("Prep", false){ prep }
time("Part 1"){ calc(input, 25) }
time("Part 2"){ calc(input, 75) }