BOARD_SIZE = 5

class Board

  attr_reader :final_score

  def initialize(data)
    @data = data.flatten
    @markers = Array.new(@data.size, false)
  end

  def has_bingo?
    !@final_score.nil?
  end

  def mark_no(no)
    i = @data.index(no)
    return false if i.nil?

    @markers[i] = true
    row = i / BOARD_SIZE
    col = i % BOARD_SIZE
    has_row = @markers[row*BOARD_SIZE..(row+1)*BOARD_SIZE-1].all?
    has_col = @markers.select.with_index{ |_,j| (j - col) % BOARD_SIZE == 0 }.all?

    bingo = has_row || has_col
    @final_score = (sum_unmarked * no) if bingo
    bingo
  end

  def sum_unmarked
    @data.each_with_index.map{ |d,i| @markers[i] ? 0 : d }.sum
  end
end


start = Time.now
input = File.readlines("input", chomp: true).filter{ |l| l != "" }
draws = input.first.split(',').map(&:to_i)
boards = input[1..-1].each_slice(BOARD_SIZE).map{ |b| b.map{ |i| i.split(' ').map(&:to_i) } }.map{ |b| Board.new(b) }
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