require '../util/grid.rb'

class Board < Grid

  def inspect
    @rows.map{ |r| r.map{ |c| c.nil? ? " " : c }.join("") }.join("\n")
  end

  def row_range(y)
    row = row(y)
    (row.index{!_1.nil?}..row.rindex{!_1.nil?})
  end

  def col_range(x)
    col = col(x)
    (col.index{!_1.nil?}..col.rindex{!_1.nil?})
  end

end

start = Time.now
input = File.read("input", chomp: true).split("\n\n")

board = Board.new( input.first.split("\n").map{ _1.chars.map{ |c| c == " " ? nil : c } } )
path = input.last.scan(/(\d+|[A-Z])/).map(&:first).map{ _1.to_i == 0 ? _1 : _1.to_i }

R = 0; D = 1; L = 2; U = 3

if board.col_count > 50
  SIDE_DIM = 50
  EDGES = {
    [1,0] => { L => [0,2,R], U => [0,3,R] },
    [2,0] => { R => [1,2,L], D => [1,1,L], U => [0,3,U] },
    [1,1] => { R => [2,0,U], L => [0,2,D] },
    [0,2] => { L => [1,0,R], U => [1,1,R] },
    [1,2] => { R => [2,0,L], D => [0,3,L] },
    [0,3] => { R => [1,2,U], D => [2,0,D], L => [1,0,D] }
  }
else
  SIDE_DIM = 4
  EDGES = {
    [2,0] => { R => [3,2,L], L => [1,1,D], U => [0,1,D] },
    [0,1] => { D => [2,2,U], L => [3,2,U], U => [2,0,D] },
    [1,1] => { D => [2,2,R], U => [2,0,R] },
    [2,1] => { R => [3,2,D] },
    [2,2] => { D => [0,1,U], L => [1,1,U] },
    [3,2] => { R => [2,0,L], D => [0,1,R], U => [2,1,L] }
  }
end

puts "Prep: #{Time.now - start}s"


def walk(board, path, part2 = false)
  x, y, dir = board.row(0).index{ _1 != nil }, 0, 0

  path.each do |i|

    if i == "L"
      dir = (dir - 1) % 4
    elsif i == "R"
      dir = (dir + 1) % 4
    else
      i.times do
        nx, ny, new_dir = x, y, dir
        case dir
        when R then nx += 1
        when D then ny += 1
        when L then nx -= 1
        when U then ny -= 1
        end

        out_of_bounds = board[nx,ny].nil?

        # === Part 1 ===
        if out_of_bounds && !part2
          case dir
          when R then nx = board.row_range(ny).first
          when D then ny = board.col_range(nx).first
          when L then nx = board.row_range(ny).last
          when U then ny = board.col_range(nx).last
          end

        # === Part 2 ===
        elsif out_of_bounds && part2
          side_x, side_y        = x / SIDE_DIM, y / SIDE_DIM
          x_on_side, y_on_side  = x - side_x * SIDE_DIM, y - side_y * SIDE_DIM
          nsx, nsy, new_dir     = EDGES[[side_x,side_y]][dir]
          nx, ny                = nsx * SIDE_DIM, nsy * SIDE_DIM

          case new_dir
          when R then
            case dir
            when R then ny += y_on_side
            when D then ny += SIDE_DIM - 1 - x_on_side
            when L then ny += SIDE_DIM - 1 - y_on_side
            when U then ny += x_on_side
            end
          when D then
            case dir
            when R then nx += SIDE_DIM - 1 - y_on_side
            when D then nx += x_on_side
            when L then nx += y_on_side
            when U then nx += SIDE_DIM - 1 - x_on_side
            end
          when L then
            nx += SIDE_DIM - 1
            case dir
            when R then ny += SIDE_DIM - 1 - y_on_side
            when D then ny += x_on_side
            when L then ny += y_on_side
            when U then ny += SIDE_DIM - 1 - x_on_side
            end
          when U then
            ny += SIDE_DIM - 1
            case dir
            when R then nx += y_on_side
            when D then nx += SIDE_DIM - 1 - x_on_side
            when L then nx += SIDE_DIM - 1 - y_on_side
            when U then nx += x_on_side
            end
          end

        end

        break if board[nx,ny] == "#"
        x, y, dir = nx, ny, new_dir

      end
    end
  end

  (y + 1) * 1000 + (x + 1) * 4 + dir
end


start = Time.now
part1 = walk(board, path)
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = walk(board, path, true)
puts "Part 2: #{part2} (#{Time.now - start}s)"