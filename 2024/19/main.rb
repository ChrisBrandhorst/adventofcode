require_relative '../util/time'

def prep
  towels, patterns = File.read("input", chomp: true).split("\n\n")
    .map{ _1.split(/, |\n/) }
end

def calc(towels, patterns)
  patterns.map{ count_opts(towels, _1) }
end

def count_opts(towels, pattern, mem = {})
  towels.sum do |t|
    if pattern == t
      1
    elsif pattern[0,t.size] == t
      subp = pattern[t.size...pattern.size]
      mem[subp] = mem[subp] || count_opts(towels, subp, mem)
    else
      0
    end
  end
end

towels, patterns = time("Prep", false){ prep }
opts = time("Calc", false){ calc(towels, patterns) }
time("Part 1"){ opts.count{ _1 > 0 } }
time("Part 2"){ opts.sum }