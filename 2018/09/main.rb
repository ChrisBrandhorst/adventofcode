INPUT_FORMAT = /(\d+) players; last marble is worth (\d+) points$/
SPECIAL_MARBLE = 23

player_count, marble_count = File.read("input").match(INPUT_FORMAT).captures.map(&:to_i)
marble_count += 1

class Circle

  def initialize
    @left = [0]
    @right = []
  end

  def next
    if @right.empty?
      @right = @left
      @left = []
    end
    @left << @right.shift
  end

  def prev
    if @left.empty?
      @left = @right
      @right = []
    end
    @right.unshift(@left.pop)
  end

  def add_marble(m)
    @left.push(m)
  end

  def delete_marble!
    @left.pop
  end

end

def play(player_count, marble_count)
  circle = Circle.new
  scores = Array.new(player_count, 0)

  (1...marble_count).each do |m|

    if m % 23 == 0
      7.times{ circle.prev }
      scores[m % player_count] += m + circle.delete_marble!
      circle.next
    else  
      circle.next
      circle.add_marble(m)
    end

  end
  scores
end

part1 = play(player_count, marble_count).max
puts "Part 1: #{part1}"

part2 = play(player_count, marble_count * 100).max
puts "Part 2: #{part2}"