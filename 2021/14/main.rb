start = Time.now
template, rules = File.read("input", chomp: true).split("\n\n")
rules = rules.split("\n").map{ |r| r.split(" -> ") }.to_h
puts "Prep: #{Time.now - start}s"


def apply_rules(pairs, rules)
  new_pairs = {}
  pairs.each do |k,v|
    insert = rules[k]
    if insert
      a, b = k[0] + insert, insert + k[-1]
      new_pairs[a] = (new_pairs[a] || 0) + v
      new_pairs[b] = (new_pairs[b] || 0) + v
    end
  end
  new_pairs
end

def calc(template, rules, steps)
  pairs = template.chars.each_cons(2).map(&:join).tally
  pairs = steps.times.inject(pairs){ |pairs| apply_rules(pairs, rules) }

  tally = {
    template[0] => 1,
    template[-1] => 1
  }
  pairs.each do |k,v|
    a, b = k.chars
    tally[a] = (tally[a] || 0) + v
    tally[b] = (tally[b] || 0) + v
  end

  tally.values.max / 2 - tally.values.min / 2
end


start = Time.now
part1 = calc(template, rules, 10)
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = calc(template, rules, 40)
puts "Part 2: #{part2} (#{Time.now - start}s)"