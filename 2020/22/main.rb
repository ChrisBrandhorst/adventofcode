require 'set'

start = Time.now
input = File.read("input").split("\n\n").map{ |d| d.split("\n").drop(1).map(&:to_i) }
puts "Prep:   #{Time.now - start}s"

def combat!(decks, recursive = false)
  game_hist = Set.new

  until decks.any?(&:empty?)
    return 0 if game_hist.include?(decks)
    game_hist << decks.map(&:dup)

    tops = decks.map(&:shift)
    winner = recursive && decks.zip(tops).all?{ |d,t| d.size >= t} ?
      combat!( decks.map.with_index{ |d,i| d.take(tops[i]) } ) : # Apparently, the player with the highest card always wins in sub-games, so sub-sub-games can be skipped
      tops.index(tops.max)

    decks[winner] += winner == 0 ? tops : tops.reverse
  end
  winner
end

def score(decks)
  decks.flatten.reverse.map.with_index{ |c,i| c * (i + 1) }.sum
end

start1 = Time.now
decks = input.map(&:clone)
combat!(decks)
part1 = score(decks)
puts "Part 1: #{part1} (#{Time.now - start1}s)"

start2 = Time.now
decks = input.map(&:clone)
combat!(decks, true)
part2 = score(decks)
puts "Part 2: #{part2} (#{Time.now - start2}s)"

puts "Total:  #{Time.now - start}s"