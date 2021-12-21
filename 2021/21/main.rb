start = Time.now
input = File.readlines("input", chomp: true).map{ |l| l[-1].to_i }
puts "Prep: #{Time.now - start}s"


def roll_dice_part1(times)
  (times**2 + times) / 2
end

def play_part1(pos, max)
  pos = pos.clone
  rolls, player, score = 0, 0, [0,0]

  loop do
    rolls += 3
    roll = roll_dice_part1(rolls) - roll_dice_part1(rolls - 3)

    pos[player] = (pos[player] - 1 + roll) % 10 + 1
    score[player] += pos[player]

    break if score[player] >= max
    player = 1 - player
  end
  score.min * rolls
end

start = Time.now
part1 = play_part1(input, 1000)
puts "Part 1: #{part1} (#{Time.now - start}s)"


def count_wins(rolls, pos, turn = 0, score = [0,0], wins_cache = {})
  key = [pos,turn,score]
  
  return wins_cache[key] if wins_cache[key]
  return [1,0] if score[0] >= 21
  return [0,1] if score[1] >= 21

  wins = [0,0]
  rolls.each do |r|
    new_pos = [pos[0], pos[1]]
    new_score = [score[0], score[1]]

    new_pos[turn] = (new_pos[turn] - 1 + r) % 10 + 1
    new_score[turn] += new_pos[turn]
    new_wins = count_wins(rolls, new_pos, 1 - turn, new_score, wins_cache)

    wins[0] += new_wins[0]
    wins[1] += new_wins[1]
  end

  wins_cache[key] = wins
end

start = Time.now
dice = [1,2,3]
rolls = dice.product(dice,dice).map(&:sum)
part2 = count_wins(rolls, input).max
puts "Part 2: #{part2} (#{Time.now - start}s)"