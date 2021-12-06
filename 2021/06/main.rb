start = Time.now
input = File.read("input", chomp: true).split(',').map(&:to_i)
puts "Prep: #{Time.now - start}s"


def reproduce(input, days)
  fish_count = input.tally
  (0..8).each{ |i| fish_count[i] ||= 0 }

  days.times do
    fish_count = fish_count.inject(fish_count.clone) do |fc,(t,c)|
      fc[t] -= c
      if t == 0
        fc[6] += c
        fc[8] += c
      else
        fc[t - 1] += c
      end
      fc
    end
  end

  fish_count
end


start = Time.now
part1 = reproduce(input, 80).values.sum
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = reproduce(input, 256).values.sum
puts "Part 2: #{part2} (#{Time.now - start}s)"