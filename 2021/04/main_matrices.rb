require 'matrix'

class Board < Matrix

  attr_reader :final_score

  def initialize(a,b)
    super(a,b)
    @markers = Matrix.zero(self.row_size) * 1
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

  def has_bingo?
    !@final_score.nil?
  end

end

start = Time.now
input = File.readlines("input", chomp: true).filter{ |l| l != "" }
puts "Prep: #{Time.now - start}s"


def init(inp)
  [
    inp.first.split(',').map(&:to_i),
    inp[1..-1].each_slice(5).map{ |b| b.map{ |i| i.split(' ').map(&:to_i) } }.map{ |bd| Board.rows(bd) }
  ]
end

start = Time.now
draws, boards = init(input)

first_board = nil
while draws.any? && first_board.nil?
  draw = draws.shift
  boards.each do |b|
    if b.mark_no(draw)
      first_board = b
      break
    end
  end
end

part1 = first_board.final_score
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
draws, boards = init(input)

last_board = nil
while draws.any?
  draw = draws.shift
  boards.each do |b|
    last_board = b if b.mark_no(draw)
  end
  boards = boards.reject(&:has_bingo?)
end

part2 = last_board.final_score
puts "Part 2: #{part2} (#{Time.now - start}s)"