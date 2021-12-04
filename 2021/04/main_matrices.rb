require 'matrix'

BOARD_SIZE = 5

class Board < Matrix

  attr_reader :final_score

  def initialize(a,b)
    super(a,b)
    @markers = Matrix.zero(self.row_size) * 1
  end

  def has_bingo?
    !@final_score.nil?
  end

  def mark_no(no)
    i = self.find_index(no)
    return false if i.nil?

    @markers[*i] = 1
    
    has_row = @markers.row(i.first).all?(1)
    has_col = @markers.column(i.last).all?(1)

    bingo = has_row || has_col
    @final_score = (sum_unmarked * no) if bingo
    bingo
  end

  def sum_unmarked
    self.each_with_index.map{ |v,r,c| @markers[r,c] == 1 ? 0 : v }.sum
  end
end


start = Time.now
input = File.readlines("input", chomp: true).filter{ |l| l != "" }
draws = input.first.split(',').map(&:to_i)
boards = input[1..-1].each_slice(BOARD_SIZE).map{ |b| b.map{ |i| i.split(' ').map(&:to_i) } }.map{ |bd| Board.rows(bd) }
puts "Prep: #{Time.now - start}s"

start = Time.now
winners = []
while draws.any?
  draw = draws.shift
  boards.reject(&:has_bingo?).each do |b|
    winners << b if b.mark_no(draw)
  end
end
part1 = winners.first.final_score
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = winners.last.final_score
puts "Part 2: #{part2} (#{Time.now - start}s)"