start = Time.now
$/*=2 # Set global line delimiter to \n\n
input = File.readlines("input", chomp: true)
puts "Prep: #{Time.now - start}s"


def go(input, part2 = false)
  monkeys = input.map do |i|
    parts = i.scan(/(\d+|([+*])|(old [+*] (old|\d+)))/m)[1..-1]
    {
      false: parts.pop[0].to_i,
      true: parts.pop[0].to_i,
      div: parts.pop[0].to_i,
      op: eval("lambda { |old| #{parts.pop[2]} }"),
      items: parts.map{_1[0].to_i},
      inspects: 0
    }
  end

  divs = monkeys.map{ _1[:div] }.inject(&:*)

  (part2 ? 10000 : 20).times do
    monkeys.each do |m|
      until m[:items].empty?
        w = m[:items].shift
        w = part2 ? m[:op].call(w) % divs : m[:op].call(w) / 3
        nm = w % m[:div] == 0 ? m[:true] : m[:false]
        monkeys[nm][:items].push(w)
        m[:inspects] += 1
      end
    end
  end

  monkeys.map{ _1[:inspects] }.max(2).inject(&:*)
end


start = Time.now
part1 = go(input)
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = go(input, true)
puts "Part 2: #{part2} (#{Time.now - start}s)"