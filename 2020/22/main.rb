require 'set'

start = Time.now
input = File.read("input").split("\n\n").map{ |p| p.split("\n").drop(1).map(&:to_i) }
puts "Prep:   #{Time.now - start}s"

def combat!(decks)
  until decks.any?{ |d| d.empty? }
    tops = decks.inject([]){ |a,d| a << d.shift; a }
    winner = tops.index(tops.max)
    decks[winner].push(tops[winner], tops[1 - winner])
  end
  winner
end

def recursive_combat!(decks)
  game_hist = Set.new

  until decks.any?{ |d| d.empty? }
    return 0 if game_hist.include?(decks)
    game_hist << decks.map{ |d| d.dup }

    tops = decks.inject([]){ |a,d| a << d.shift; a }

    winner = (0...decks.size).all?{ |i| decks[i].size >= tops[i] } ?
      recursive_combat!( decks.map.with_index{ |d,i| d.take(tops[i]) } ) :
      tops.index(tops.max)

    decks[winner].push(tops[winner], tops[1 - winner])
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
recursive_combat!(decks)
part2 = score(decks)
puts "Part 2: #{part2} (#{Time.now - start2}s)"

puts "Total:  #{Time.now - start}s"