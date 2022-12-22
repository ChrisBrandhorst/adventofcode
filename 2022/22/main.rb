require '../util/grid.rb'

class Board < Grid

  def inspect
    @rows.map{ |r| r.map{ |c| c.nil? ? " " : c }.join("") }.join("\n")
  end

  def row_range(y)
    (@rows[y].index{!_1.nil?}..@rows[y].rindex{!_1.nil?})
  end

  def col_range(x)
    col = (0...@row_count).map{ @rows[_1][x] }
    (col.index{!_1.nil?}..col.rindex{!_1.nil?})
  end

end

start = Time.now
input = File.read("input", chomp: true).split("\n\n")

board = Board.new( input.first.split("\n").map{ _1.chars.map{ |c| c == " " ? nil : c } } )
path = input.last.scan(/(\d+|[A-Z])/).map.with_index{ _2 % 2 == 0 ? _1.first.to_i : _1.first }

R = 0; D = 1; L = 2; U = 3

if board.col_count > 50
  SIDE_DIM = 50
  EDGES = {
    [1,0] => {
      L =>  { side: [0,2], dir: R },
      U =>  { side: [0,3], dir: R }
    },
    [2,0] => {
      R =>  { side: [1,2], dir: L },
      D =>  { side: [1,1], dir: L },
      U =>  { side: [0,3], dir: U }
    },
    [1,1] => {
      R =>  { side: [2,0], dir: U },
      L =>  { side: [0,2], dir: D }
    },
    [0,2] => {
      L =>  { side: [1,0], dir: R },
      U =>  { side: [1,1], dir: R }
    },
    [1,2] => {
      R =>  { side: [2,0], dir: L },
      D =>  { side: [0,3], dir: L }
    },
    [0,3] => {
      R =>  { side: [1,2], dir: U },
      D =>  { side: [2,0], dir: D },
      L =>  { side: [1,0], dir: D }
    }
  }
else
  SIDE_DIM = 4
  EDGES = {
    [2,0] => {
      R =>  { side: [3,2], dir: L },
      L =>  { side: [1,1], dir: D },
      U =>  { side: [0,1], dir: D }
    },
    [0,1] => {
      D =>  { side: [2,2], dir: U },
      L =>  { side: [3,2], dir: U },
      U =>  { side: [2,0], dir: D }
    },
    [1,1] => {
      D =>  { side: [2,2], dir: R },
      U =>  { side: [2,0], dir: R }
    },
    [2,1] => {
      R =>  { side: [3,2], dir: D }
    },
    [2,2] => {
      D =>  { side: [0,1], dir: U },
      L =>  { side: [1,1], dir: U }
    },
    [3,2] => {
      R =>  { side: [2,0], dir: L },
      D =>  { side: [0,1], dir: R },
      U =>  { side: [2,1], dir: L }
    }
  }
end

puts "Prep: #{Time.now - start}s"


def walk(board, path, part2 = false)

  x, y = board.row(0).index("."), 0
  dir = 0
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

          side = [x / SIDE_DIM, y / SIDE_DIM]
          
          x_on_side = x - side[0] * SIDE_DIM
          y_on_side = y - side[1] * SIDE_DIM

          edge = EDGES[side][dir]
          new_side = edge[:side]
          new_dir = edge[:dir]

          nx = new_side[0] * SIDE_DIM
          ny = new_side[1] * SIDE_DIM

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
        x, y = nx, ny
        dir = new_dir

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