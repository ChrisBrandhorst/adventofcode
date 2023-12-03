require '../util/grid'
require 'set'


start = Time.now
input = File.readlines("input", chomp: true).map(&:chars)
engine = Grid.new(input)
engine.with_diag!
puts "Prep: #{Time.now - start}s"


start = Time.now
parts_sum = 0
all_gears = {}
is_part = false
part_num = 0
adj_gears = Set.new

engine.each do |c,v|
  if v =~ /\d/
    part_num = (part_num * 10 || 0) + v.to_i
    engine.each_adj(c) do |ac,av|
      is_part ||= av !~ /[\d\.]/
      adj_gears << ac if av == "*"
      all_gears[ac] ||= []
    end
  else
    if is_part
      parts_sum += part_num
      adj_gears.each{ all_gears[_1] << part_num }
    end
    is_part = false
    part_num = 0
    adj_gears = Set.new
  end
end
part1 = parts_sum
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = all_gears.values.sum{ _1.size == 2 ? _1[0] * _1[-1] : 0 }
puts "Part 2: #{part2} (#{Time.now - start}s)"