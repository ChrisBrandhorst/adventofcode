require_relative '../util/time'

def prep
  rules, updates = File.read("input", chomp: true)
    .split("\n\n")
    .map{ |b| b.split("\n").map{ _1.split(/[|,]/).map(&:to_i) } }

  correct, corrected = [], []

  updates.each do |u|
    if u.each_cons(2).all?{ rules.include?(_1) }
      correct << u
    else
      u_rules = rules.select{ (_1 & u).size == 2 }
      corrected << u.sort do |a,b|
        u_rules.detect{ _1.include?(a) && _1.include?(b) }.first == a ? -1 : 1
      end
    end
  end

  [correct, corrected]
end

def get_middle_sum(updates)
  updates.sum{ _1[_1.size/2] }
end

correct, corrected = time("Prep", false){ prep }
time("Part 1"){ get_middle_sum(correct) }
time("Part 2"){ get_middle_sum(corrected) }