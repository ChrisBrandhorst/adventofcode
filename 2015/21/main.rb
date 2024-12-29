start = Time.now
boss = File.readlines("boss", chomp: true).map{ a = _1.scan(/([^:]+): (\d+)/).first; [a[0].split.join.downcase.to_sym, a[1].to_i] }.to_h
shop = File.read("shop", chomp: true).split("\n\n").map do |l|
  lines = l.split("\n")
  [
    lines.first[0...lines.first.index(":")].downcase.to_sym,
    lines[1..-1].map{ c = _1.scan(/\s\d+/).map(&:to_i); {cost: c[0], damage: c[1], armor: c[2]} }
  ]
end.to_h
player = { hitpoints: 100, damage: 0, armor: 0 }
puts "Prep: #{Time.now - start}s"


def fight(player, boss)
  turn = [player, boss]
  while true
    turn.last[:hitpoints] -= turn.first[:damage] - turn.last[:armor]
    return [player[:cost], true] if boss[:hitpoints] <= 0
    return [player[:cost], false] if player[:hitpoints] <= 0
    turn.reverse!
  end
end


start = Time.now

fights = []
shop[:weapons].each do |w|
  ([{cost:0,damage:0,armor:0}] + shop[:armor]).each do |a|
    (0..2).map{ shop[:rings].combination(_1).to_a }.flatten(1).each do |r|
      inv = [w, a] + r
      o = player.merge( cost: inv.sum{_1[:cost]} )
      o[:damage] += inv.sum{_1[:damage]}
      o[:armor] += inv.sum{_1[:armor]}
      fights << fight(o, boss.clone)
    end
  end
end

part1 = fights.filter_map{ _1 if _2 }.min
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = fights.filter_map{ _1 unless _2 }.max
puts "Part 2: #{part2} (#{Time.now - start}s)"