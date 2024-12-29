start = Time.now
input = File.readlines("input", chomp: true).map(&:to_i)
puts "Prep: #{Time.now - start}s"


def get_qe(packages, groups = 3)
  group_weight = packages.sum / groups

  qe_min = Float::INFINITY
  (0..packages.size).each do |s|
    packages.combination(s).select{ _1.sum == group_weight }.each do |g|
      qe = g.inject(&:*)
      qe_min = qe if qe < qe_min
    end
    break if qe_min != Float::INFINITY
  end

  qe_min
end


start = Time.now
part1 = get_qe(input)
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = get_qe(input, 4)
puts "Part 2: #{part2} (#{Time.now - start}s)"