start = Time.now
boss = File.readlines("input", chomp: true)
  .map{ a = _1.scan(/([^:]+): (\d+)/).first; [a[0].split.join.downcase.to_sym, a[1].to_i] }
  .to_h
spells = {
  :magic_missile => { cost: 53, damage: 4 },
  :drain =>         { cost: 73, damage: 2, heal: 2 },
  :shield =>        { cost: 113, effect: { duration: 6, armor: 7 } },
  :poison =>        { cost: 173, effect: { duration: 6, damage: 3 } },
  :recharge =>      { cost: 229, effect: { duration: 5, mana: 101 } }
}
player = { hitpoints: 50, mana: 500 }
puts "Prep: #{Time.now - start}s"


def play(player, boss, spells, hard = false, effects = [], spent = 0, turn = 0)
  pl_hp, pl_mana = player[:hitpoints], player[:mana]
  boss_hp, boss_dam = boss[:hitpoints], boss[:damage]
  min_win = Float::INFINITY

  q = []
  q << [pl_hp, pl_mana, boss_hp, effects, spent, turn]
  until q.empty?
    pl_hp, pl_mana, boss_hp, effects, spent, turn = q.pop

    pl_armor = 0
    pl_hp -= 1 if turn == 0 && hard

    effects = effects.inject({}) do |ne,(n,duration)|
      eff = spells[n][:effect]
      pl_armor  += eff[:armor]  if eff[:armor]
      boss_hp   -= eff[:damage] if eff[:damage]
      pl_mana   += eff[:mana]   if eff[:mana]
      ne[n] = duration - 1 if duration > 1
      ne
    end

    if boss_hp <= 0
      min_win = spent if spent < min_win
      next
    end
    next if pl_hp <= 0 || spent > min_win

    # Player
    if turn == 0
      
      spells.each do |n,s|
        next if effects.include?(n)
        next if s[:cost] > pl_mana

        new_effects = effects.dup
        new_effects[n] = s[:effect][:duration] if s[:effect]

        q << [
          pl_hp + (s[:heal] || 0),
          pl_mana - s[:cost],
          boss_hp - (s[:damage] || 0),
          new_effects,
          spent + s[:cost],
          1 - turn
        ]
      end

    # Boss
    else
      q << [
        pl_hp - [boss_dam - pl_armor, 1].max,
        pl_mana,
        boss_hp,
        effects,
        spent,
        1 - turn
      ]
    end
  end

  min_win
end


start = Time.now
@min_win = Float::INFINITY
part1 = play(player, boss, spells)
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
@min_win = Float::INFINITY
part2 = play(player, boss, spells, true)
puts "Part 2: #{part2} (#{Time.now - start}s)"