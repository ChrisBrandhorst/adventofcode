start = Time.now
input = File.readlines("input", chomp: true).map{ r = _1.split; [r.first.chars, r.last.to_i] }
puts "Prep: #{Time.now - start}s"


def winnings(hb, do_jokers = false)
  strength = "AKQJT98765432".chars.reverse
  strength.unshift(strength.delete("J")) if do_jokers

  sb = hb.map do |hand,bid|
    cards = hand.map{ strength.index(_1) }
    tally = cards.tally
    jokers = tally[0] || 0
    tally.delete(0) if do_jokers && jokers > 0
    sorted_counts = tally.values.sort.reverse
    sorted_counts[0] = (sorted_counts[0] || 0) + jokers if do_jokers
    [sorted_counts + cards, bid]
  end

  sb.sort_by(&:first).each_with_index.sum{ (_2+1) * _1[1] }
end


start = Time.now
part1 = winnings(input)
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = winnings(input, true)
puts "Part 2: #{part2} (#{Time.now - start}s)"