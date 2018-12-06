particles = File.readlines("input").map do |i|
  v = i.scan(/[\d-]+/)
  {
    p: [v[0].to_i, v[1].to_i, v[2].to_i],
    v: [v[3].to_i, v[4].to_i, v[5].to_i],
    a: [v[6].to_i, v[7].to_i, v[8].to_i]
  }
end

x = 0; y = 1; z = 2

accels = particles.map{ |p| p[:a][x].abs + p[:a][y].abs + p[:a][z].abs }
puts "Part 1: #{accels.index(accels.min)}"

prev_particle_count = particles.size
loop do

  particles.each do |pt|

    pt[:v][x] += pt[:a][x]
    pt[:v][y] += pt[:a][y]
    pt[:v][z] += pt[:a][z]
    pt[:p][x] += pt[:v][x]
    pt[:p][y] += pt[:v][y]
    pt[:p][z] += pt[:v][z]

    pt[:d] = pt[:p].map(&:abs).sum

  end

  positions = particles.map{ |pt| pt[:p] }
  duplicates = positions.each_index.group_by{ |i| positions[i] }.values.select{ |v| v.length > 1 }.flatten
  particles = particles.reject.with_index { |e,i| duplicates.include? i }

  distances = particles.map{ |pt| pt[:d] }
  minidx = distances.index(distances.min)

  accels = particles.map{ |p| p[:a][x].abs + p[:a][y].abs + p[:a][z].abs }
  
  break if minidx == accels.index(accels.min) && prev_particle_count == particles.size
  prev_particle_count = particles.size
end

puts "Part 2: #{particles.size}"