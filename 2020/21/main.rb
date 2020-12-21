start = Time.now
input = File.readlines("input", chomp: true).map do |l|
  c = l.delete_suffix(')').split(" (contains ")
  [ c.first.split(' '), c.last.split(', ') ]
end
puts "Prep:   #{Time.now - start}s"

start1 = Time.now

# Make allergens to ingredients hash
all_to_ing = {}
input.each do |is,as|
  as.each do |a|
    # Use intersection, so we already remove some possibilities
    all_to_ing[a] = all_to_ing.has_key?(a) ? all_to_ing[a] & is : is
  end
end

# While there are allergens with uncertain ingredients
while all_to_ing.values.any?{ |is| is.size != 1 } do
  # Select all allergens with a known ingredient
  all_to_ing.select{ |a,is| is.size == 1 }.each do |ka,(ki)|
    # Remove that ingredient from all lines, as a new object 'cause we're iterating over it
    all_to_ing = all_to_ing.map{ |asn,isn| [ asn, asn == ka ? isn : isn - [ki] ] }.to_h
  end
end

part1 = (input.map(&:first).flatten - all_to_ing.values.flatten).size
puts "Part 1: #{part1} (#{Time.now - start1}s)"

start2 = Time.now
part2 = all_to_ing.sort_by{ |a,i| a }.map{ |a,(i)| i }.join(',')
puts "Part 2: #{part2} (#{Time.now - start2}s)"

puts "Total:  #{Time.now - start}s"