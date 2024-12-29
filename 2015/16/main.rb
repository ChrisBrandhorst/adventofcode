start = Time.now
input = File.readlines("input", chomp: true).map do |l|
  l.split[2..-1].each_slice(2).map{ [_1.chop, _2.to_i] }.to_h
end

tape = "children: 3
cats: 7
samoyeds: 2
pomeranians: 3
akitas: 0
vizslas: 0
goldfish: 5
trees: 3
cars: 2
perfumes: 1"

mfcsam = tape.split.each_slice(2).map{ [_1.chop, _2.to_i] }.to_h
puts "Prep: #{Time.now - start}s"


start = Time.now
sue = input.detect{ |s| s.all?{ _2 == mfcsam[_1] } }
part1 = input.index(sue) + 1
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
sue = input.detect do |s|
  s.all? do
    v = mfcsam[_1]
    case _1
    when "cats", "trees";           _2 > v
    when "pomeranians", "goldfish"; _2 < v
    else;                           _2 == v
    end
  end
end
part2 = input.index(sue) + 1
puts "Part 2: #{part2} (#{Time.now - start}s)"