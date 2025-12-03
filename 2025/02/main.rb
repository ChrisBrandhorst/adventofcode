require_relative '../util/time'

def prep
  File.read("input", chomp: true)
    .split(",")
    .map{ _1.split("-") }
end

def invalids_sum(input, part2 = false)
  input.inject(0) do |invalids,(a,b)|
    (a..b).each do |id|
      invalids += id.to_i if is_invalid?(id, part2 ? (1..id.length/2) : [id.length / 2])
    end
    invalids
  end
end

def is_invalid?(id, part_lenghts)
  l = id.length
  part_lenghts.each do |lp|
    next if lp == 0 || l % lp != 0
    return true if id[0...lp] * (l / lp) == id
  end
  false
end

input = time("Prep", false){ prep }
time("Part 1"){ invalids_sum(input) }
time("Part 2"){ invalids_sum(input, true) }




# prt = id[0...lp].to_i
# return true if (0...(l/lp)).sum{ prt * 10**(_1*lp) } == i