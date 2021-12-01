start = Time.now
input = File.read("input").split("\n\n")

rules = input.shift.split("\n").map{ |r|
  c = r.match(/^(\d+): (.*)$/).captures
  w = c.last.match(/"([\w])"/)
  w ? [c.first.to_i, w.captures.first] : [c.first.to_i, c.last.split(' | ').map{ |a| a.split(' ').map(&:to_i) } ]
}.to_h

messages = input.shift.split("\n")
puts "Prep:   #{Time.now - start}s"

REPEAT = "REPEAT"

start1 = Time.now

@collapsed = {}

def collapse_rule(rules, n = 0)
  if rules[n].is_a?(String)
    rules[n]
  else
    rules[n].map do |opt|
      opt.map do |r|
        ret = r == n ? n : collapse_rule(rules, r)
        @collapsed[r] = ret
        ret
      end
    end
  end
end

def generate_messages(rules, message = "", level = 0)
  messages = [message]

  rules.each do |r|
    if r.is_a?(Integer)
      if level < 1 && r == 8
        # p message
        # p gsm = generate_messages( [@collapsed[r]], message, level + 1).flatten
        messages = gsm.map{ |gm| message + gm }
      else
        messages = messages.map{ |m| m + REPEAT }
      end
    elsif r.is_a?(String)
      messages = messages.map{ |m| m + r }
    else
      messages = messages.map{ |m| r.map{ |s| generate_messages(s, m, level) } }.flatten
    end
  end

  messages
end

def is_valid?(rule, message, i = 0, all = false)

  if rule.is_a?(String)
    message[i] == rule
  elsif rule.is_a?(Integer)
    puts "HUH"
  else
    valid = all ? true : false
    puts "#{rule} , #{all}"
    rule.each_with_index do |r,j|
      v = is_valid?(r, message, i + (all ? j : 0), !all)
      if all
        valid &&= v
      else
        valid ||= v
        return true if valid
      end
    end
    valid
  end

end

collapsed = collapse_rule(rules)
possibles = generate_messages( collapsed.first )
p possibles.size
part1 = (messages & possibles).count
puts "Part 1: #{part1} (#{Time.now - start1}s)"

start2 = Time.now

rules[8] = [[42], [42, 8]]
rules[11] = [[42, 31], [42, 11, 31]]

collapsed = collapse_rule(rules, 0)
@collapsed[0] = collapsed


puts generate_messages( [ @collapsed[8] ] )

# possibles = generate_messages( collapsed.first )
# puts possibles

part2 = (messages & possibles).count
puts "Part 2: #{part2} (#{Time.now - start2}s)"

puts "Total:  #{Time.now - start}s"