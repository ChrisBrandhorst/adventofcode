require_relative '../util/time'

def prep
  max = nil
  these, those = File.read("input", chomp: true)
    .split("\n\n")
    .map{ _1.split.map(&:chars) }
    .partition{ _1.first.uniq == ["#"] }
    .map{ |k| k.map{ |t|
      t = t.transpose
      max = t.first.size - 2 unless max
      t.map{ _1.count("#") - 1 }
    } }
  [these, those, max]
end

def part1(these, those, max)
  these.sum do |a|
    those.count do |b|
      a.zip(b).map(&:sum).all?{ _1 <= max }
    end
  end
end

these, those, max = time("Prep", false){ prep }
time("Part 1"){ part1(these, those, max) }