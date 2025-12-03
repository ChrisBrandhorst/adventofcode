require_relative '../util/time'

def prep
  File.readlines("input", chomp: true)
    .map{ _1.chars.map(&:to_i) }
end

def max_joltage(input, batt)
  input.sum do |bank|
    i = 0
    (-batt..-1).each_with_object([]) do |j,max|
      m, id = bank[i..j].each_with_index.max{ _1[0] <=> _2[0] }
      max << m
      i += id + 1
    end.join.to_i
  end
end

input = time("Prep", false){ prep }
time("Part 1"){ max_joltage(input, 2) }
time("Part 2"){ max_joltage(input, 12) }