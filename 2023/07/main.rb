class Hand

  def initialize(chars)
    @chars = chars
  end

  def cards_strength
    @cards_strength ||= %w{A K Q J T 9 8 7 6 5 4 3 2}.reverse
  end

  def [](i)
    @chars[i]
  end

  def inspect
    @chars.join
  end

  def strength
    tally = @chars.tally

    if tally.size == 5
      0
    elsif tally.size == 1
      6
    elsif tally.any?{ _2 == 4 }
      5
    elsif tally.count{ _2 == 3 } == 1
      if tally.count{ _2 == 2 } == 1
        4
      else
        3
      end
    elsif tally.count{ _2 == 2 } == 2
      2
    elsif tally.count{ _2 == 2 } == 1
      1
    end
  end

  def <=>(other)
    comp = self.strength <=> other.strength
    if comp == 0
      @chars.each_with_index do |c,i|
        comp = self.cards_strength.index(c) <=> self.cards_strength.index(other[i])
        break if comp != 0
      end
    end
    comp
  end

end



class JokerHand < Hand

  def cards_strength
    @cards_strength ||= %w{A K Q T 9 8 7 6 5 4 3 2 J}.reverse
  end

  def strength
    tally = @chars.tally
    jokers = tally["J"] || 0

    if jokers > 0 && jokers < 5
      tally.delete("J")
      strengths = tally.map do |c,i|
        new_tally = tally.clone
        new_tally[c] += jokers
        get_strength(new_tally)
      end
      strengths.max
    else
      get_strength(tally)
    end

  end

  def get_strength(tally)
    if tally.size == 5
      0
    elsif tally.size == 1
      6
    elsif tally.any?{ _2 == 4 }
      5
    elsif tally.count{ _2 == 3 } == 1
      if tally.count{ _2 == 2 } == 1
        4
      else
        3
      end
    elsif tally.count{ _2 == 2 } == 2
      2
    elsif tally.count{ _2 == 2 } == 1
      1
    end
  end


end


start = Time.now
puts "Prep: #{Time.now - start}s"


start = Time.now
input = File.readlines("input", chomp: true).map{ r = _1.split; [Hand.new(r.first.chars), r.last.to_i] }
part1 = input.sort.each_with_index.sum{ |(h,b),i| (i+1)*b }
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
input = File.readlines("input", chomp: true).map{ r = _1.split; [JokerHand.new(r.first.chars), r.last.to_i] }
part2 = input.sort.each_with_index.sum{ |(h,b),i| (i+1)*b }
puts "Part 2: #{part2} (#{Time.now - start}s)"


# p JokerHand.new("JKKK2".chars) <=> JokerHand.new("QQQQ2".chars)

