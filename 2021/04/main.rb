start = Time.now
input = File.readlines("input", chomp: true).filter{ |l| l != "" }
puts "Prep: #{Time.now - start}s"

def init(inp)
  [
    inp.first.split(',').map(&:to_i),
    inp[1..-1].each_slice(5).map{ |b| b.map{ |i| i.split(' ').map(&:to_i) } }.map{ |b| Board.new(b) }
  ]
end

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
    row = i / 5
    col = i % 5
    has_row = @markers[(row*5)..(row*5+5-1)].all?(true)
    has_col = @markers.select.with_index{ |_,j| (j - col) % 5 == 0 }.all?(true)

    bingo = has_row || has_col
    @final_score = (sum_unmarked * no) if bingo
    bingo
  end

  def sum_unmarked
    @data.each_with_index.map{ |d,i| @markers[i] ? 0 : d }.sum
  end

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