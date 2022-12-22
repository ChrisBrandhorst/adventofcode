require '../util/grid.rb'

class Board < Grid

  def inspect
    @rows.map{ |r| r.map{ |c| c.nil? ? " " : c }.join("") }.join("\n")
  end

  def [](x, y = nil)
    super(x, y) || " "
  end

  def row_range(y)
    (@rows[y].index{!_1.nil?}..@rows[y].rindex{!_1.nil?})
  end

  def col_range(x)
    col = (0...@row_count).map{ @rows[_1][x] }
    (col.index{!_1.nil?}..col.rindex{!_1.nil?})
  end

  def start_pos
    [@rows[0].index("."), 0]
  end

end

start = Time.now
input = File.read("input", chomp: true).split("\n\n")

board = Board.new( input.first.split("\n").map{ _1.chars.map{ |c| c == " " ? nil : c } } )
path = input.last.scan(/(\d+|[A-Z])/).map.with_index{ _2 % 2 == 0 ? _1.first.to_i : _1.first }

if board.col_count > 50
  SIDE_DIM = 50
  EDGES = {
    [1,0] => {
      2 =>  { side: [0,2], dir: 0 },
      3 =>  { side: [0,3], dir: 0 }
    },
    [2,0] => {
      0 =>  { side: [1,2], dir: 2 },
      1 =>  { side: [1,1], dir: 2 },
      3 =>  { side: [0,3], dir: 3 }
    },
    [1,1] => {
      0 =>  { side: [2,0], dir: 3 },
      2 =>  { side: [0,2], dir: 1 }
    },
    [0,2] => {
      2 =>  { side: [1,0], dir: 0 },
      3 =>  { side: [1,1], dir: 0 }
    },
    [1,2] => {
      0 =>  { side: [2,0], dir: 2 },
      1 =>  { side: [0,3], dir: 2 }
    },
    [0,3] => {
      0 =>  { side: [1,2], dir: 3 },
      1 =>  { side: [2,0], dir: 1 },
      2 =>  { side: [1,0], dir: 1 }
    }
  }
else
  SIDE_DIM = 4
  EDGES = {
    [2,0] => {
      0 =>  { side: [3,2], dir: 2 },
      2 =>  { side: [1,1], dir: 1 },
      3 =>  { side: [0,1], dir: 1 }
    },
    [0,1] => {
      1 =>  { side: [2,2], dir: 3 },
      2 =>  { side: [3,2], dir: 3 },
      3 =>  { side: [2,0], dir: 1 }
    },
    [1,1] => {
      1 =>  { side: [2,2], dir: 0 },
      3 =>  { side: [2,0], dir: 0 }
    },
    [2,1] => {
      0 =>  { side: [3,2], dir: 1 }
    },
    [2,2] => {
      1 =>  { side: [0,1], dir: 3 },
      2 =>  { side: [1,1], dir: 3 }
    },
    [3,2] => {
      0 =>  { side: [2,0], dir: 2 },
      1 =>  { side: [0,1], dir: 0 },
      3 =>  { side: [2,1], dir: 2 }
    }
  }
end

puts "Prep: #{Time.now - start}s"





def walk(board, path, part2 = false)

  pos = board.start_pos
  dir = 0
  path.each do |i|

    if i == "L"
      dir = (dir - 1) % 4
    elsif i == "R"
      dir = (dir + 1) % 4
    else
      i.times do
        x, y = pos
        case dir
        when 0 then x += 1
        when 1 then y += 1
        when 2 then x -= 1
        when 3 then y -= 1
        end
        new_pos = [x,y]


        unless part2

          # === Part 1 ===
          if board[new_pos] == " "
            case dir
            when 0 then x = board.row_range(y).first
            when 1 then y = board.col_range(x).first
            when 2 then x = board.row_range(y).last
            when 3 then y = board.col_range(x).last
            end
            new_pos = [x,y]
          end

          break if board[new_pos] == "#"
          pos = new_pos

        else

          # === Part 2 ===
          if board[new_pos] == " "
            side = [pos[0] / SIDE_DIM,  pos[1] / SIDE_DIM]
            
            x_on_side = pos[0] - side[0] * SIDE_DIM
            y_on_side = pos[1] - side[1] * SIDE_DIM

            edge = EDGES[side][dir]
            new_side = edge[:side]
            new_dir = edge[:dir]

            x = new_side[0] * SIDE_DIM
            y = new_side[1] * SIDE_DIM

            case new_dir
            when 0 then
              case dir
              when 0 then y += y_on_side; puts "UNUSED"
              when 1 then y += SIDE_DIM - 1 - x_on_side; puts "UNUSED"
              when 2 then y += SIDE_DIM - 1 - y_on_side
              when 3 then y += x_on_side
              end
            when 1 then
              case dir
              when 0 then x += SIDE_DIM - 1 - y_on_side
              when 1 then x += x_on_side
              when 2 then x += y_on_side
              when 3 then x += SIDE_DIM - 1 - x_on_side; puts "UNUSED"
              end
            when 2 then
              x += SIDE_DIM - 1
              case dir
              when 0 then y += SIDE_DIM - 1 - y_on_side
              when 1 then y += x_on_side
              when 2 then y += y_on_side; puts "UNUSED"
              when 3 then y += SIDE_DIM - 1 - x_on_side; puts "UNUSED"
              end
            when 3 then
              y += SIDE_DIM - 1
              case dir
              when 0 then x += y_on_side
              when 1 then x += SIDE_DIM - 1 - x_on_side
              when 2 then x += SIDE_DIM - 1 - y_on_side; puts "UNUSED"
              when 3 then x += x_on_side
              end
            end

            new_pos = [x,y]
          end

          break if board[new_pos] == "#"
          pos = new_pos
          dir = new_dir unless new_dir.nil?
        end

      end

    end

  end

  (pos[1] + 1) * 1000 + (pos[0] + 1) * 4 + dir

end


start = Time.now
part1 = walk(board, path)
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = walk(board, path, true)
puts "Part 2: #{part2} (#{Time.now - start}s)"