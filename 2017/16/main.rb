input = File.read("input").split(',')

# input = ["s1", "x3/4", "pe/b"]
# positions = [*'a'..'e']

def dance(steps, positions)
  new_positions = positions.clone
  steps.each do |step|
    if step =~ /s(\d+)/
      pos = $1.to_i
      new_positions = new_positions[-pos..-1] + new_positions[0..-1-pos]
    else
      if step =~ /x(\d+)\/(\d+)/
        a = $1.to_i; b = $2.to_i
      elsif step =~ /p([a-z])\/([a-z])/
        a = new_positions.index($1); b = new_positions.index($2)
      end
      new_positions[a], new_positions[b] = new_positions[b], new_positions[a]
    end
  end
  new_positions
end

original = [*'a'..'p']
positions = dance(input, original)
puts "Part 1: #{positions.join}"

history = [original]
while positions != original
  history << positions
  positions = dance(input, positions)
end
puts "Part 2: #{history[1000000000 % history.size].join}"