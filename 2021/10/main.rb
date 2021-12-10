start = Time.now
input = File.readlines("input", chomp: true)

PAIRS = { '(' => ')', '[' => ']', '{' => '}', '<' => '>' }
OPENS = PAIRS.keys
CLOSES = PAIRS.values
SYNTAX_POINTS = CLOSES.each_with_index.inject({}){ |r,(c,i)| r[c] = 3 * 19**[i,1].min * 21**[0,i-1].max; r }
REGEX = Regexp.new('(' + PAIRS.to_a.map{ |p| Regexp.escape(p.join) }.join('|') + ')')

puts "Prep: #{Time.now - start}s"


start = Time.now

errors, incomplete = [], []
input.each do |l|
  l.gsub!(REGEX, "") while l =~ REGEX
  ci = l.chars.index{ |c| CLOSES.include?(c) }
  if ci.nil?
    incomplete << l
  else
    errors << l[ci]
  end
end

part1 = errors.compact.map{ |e| SYNTAX_POINTS[e] }.sum
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
points = incomplete.map{ |l| l.chars.reverse.inject(0){ |s,c| s * 5 + (OPENS.index(c) + 1) } }
part2 = points.sort[points.size / 2]
puts "Part 2: #{part2} (#{Time.now - start}s)"