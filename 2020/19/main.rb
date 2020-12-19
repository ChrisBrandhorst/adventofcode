start = Time.now
input = File.read("input").split("\n\n")

rules = input.shift.split("\n").map{ |r|
  c = r.match(/^(\d+): (.*)$/).captures
  w = c.last.match(/"([\w])"/)
  w ? [c.first.to_i, w.captures.first] : [c.first.to_i, c.last.split(' | ').map{ |a| a.split(' ').map(&:to_i) } ]
}.to_h

messages = input.shift.split("\n")
puts "Prep:   #{Time.now - start}s"

def build_regex_str(rules, n = 0)
  if rules[n].is_a?(String)
    rules[n]
  else
    ret = rules[n].map do |opt|
      opt.map{ |r| r == n ? n : build_regex_str(rules, r) }.join('')
    end
    "(#{ret.join('|')})"
  end
end

def count(messages, regex_str)
  regex = Regexp.new("^#{regex_str}$")
  messages.select{ |m| m =~ regex }.count
end

start1 = Time.now
part1 = count(messages, build_regex_str(rules))
puts "Part 1: #{part1} (#{Time.now - start1}s)"

start2 = Time.now

rules[8] = [[42], [42, 8]]
rules[11] = [[42, 31], [42, 11, 31]]
regex_str = build_regex_str(rules)

rule_8 = build_regex_str(rules, 8)
regex_str.sub!("8", "(#{rule_8})+")

rule_11 = build_regex_str(rules, 11)
3.times{ regex_str.sub!("11", rule_11) }

part2 = count(messages, regex_str)
puts "Part 2: #{part2} (#{Time.now - start2}s)"

puts "Total:  #{Time.now - start}s"