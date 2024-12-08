require_relative '../util/time'

def prep
  rules, updates = File.read("input", chomp: true)
    .split("\n\n")
    .map{ |b| b.split("\n").map{ _1.split(/[|,]/).map(&:to_i) } }

  correct, incorrect = updates.partition{ |u| u.each_cons(2).all?{ rules.include?(_1) } }
  [rules, correct, incorrect]
end

def get_middle_sum(updates)
  updates.sum{ _1[_1.size/2] }
end

def part2(rules, updates)
  updates.each do |u|
    u_rules = rules.select{ (_1 & u).size == 2 }
    u.sort!{ |a,b| u_rules.detect{ _1.include?(a) && _1.include?(b) }.first == a ? -1 : 1 }
  end
  get_middle_sum(updates)
end

rules, correct, incorrect = time("Prep", false){ prep }
time("Part 1"){ get_middle_sum(correct) }
time("Part 2"){ part2(rules, incorrect) }