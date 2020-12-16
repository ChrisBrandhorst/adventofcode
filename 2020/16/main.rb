start = Time.now
input = File.read("input").split("\n\n")

fields = input.shift.split("\n").map{ |f| [
  f[0...f.index(':')],
  f.scan(/(\d+)-(\d+)/).map{ |a| (a.first.to_i..a.last.to_i) }
] }.to_h
your = input.shift.split("\n").last.split(",").map(&:to_i)
nearby = input.shift.split("\n").drop(1).map{ |n| n.split(",").map(&:to_i) }

ranges = fields.values.flatten(1)
puts "Prep:   #{Time.now - start}s"

start1 = Time.now
part1 = nearby.flatten.sum{ |v| ranges.any?{ |r| r === v } ? 0 : v }
puts "Part 1: #{part1} (#{Time.now - start1}s)"

start2 = Time.now

# Get all tickets for which all values match any range
valid = nearby.select{ |n| n.all?{ |v| ranges.any?{ |r| r === v } } }

# Get all possible fields for all positions
poss = (0...your.size).map{ |i|
  valid
    .map{ |v| v[i] }
    .map{ |v|
      fields.keys.select{ |k|
        fields[k].any?{ |r| r === v }
      }
    }
    .reduce(&:&)
}

# Reduce positions by repeatedly fixating fields with only one option
idx_to_field = {}
until idx_to_field.keys.size == your.size
  i = poss.index{ |p| p.size == 1 }
  field = poss[i].first
  idx_to_field[i] = field
  poss.each{ |p| p.delete(field) }
end

part2 = idx_to_field.map{ |k,v| v.start_with?("departure") ? your[k] : 1 }.reduce(&:*)
puts "Part 2: #{part2} (#{Time.now - start2}s)"

puts "Total:  #{Time.now - start}s"