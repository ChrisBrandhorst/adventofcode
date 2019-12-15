require '../intcode/intcode'

input = File.read("input").split(",").map(&:to_i)

class Tile
  EMPTY = 0
  WALL = 1
  BLOCK = 2
  PADDLE = 3
  BALL = 4
end

class Arcade

  attr_reader :tiles, :score

  def initialize(input)
    @input = input
  end

  def set_tile(x, y, tile)
    @tiles[y] ||= []
    @tiles[y][x] = tile
    [x, y]
  end

  def run!(coins = 1, vis = false)
    intcode = Intcode.new(@input)
    intcode[0] = coins

    @tiles = []
    @score = 0

    i = 0
    x = y = -1

    paddle_pos = ball_pos = nil

    started = false
    
    intcode.run do |op,out|

      if op == :out

        case i
        when 0
          x = out
        when 1
          y = out
        when 2

          if x == -1 && y == 0
            @score = out
          else
            set_tile(x, y, out)
            if out == Tile::PADDLE
              paddle_pos = [x,y]
            elsif out == Tile::BALL
              ball_pos = [x,y]
            end
          end

          if vis && started
            print "\e[2J\e[f"
            puts render
            sleep(0.01)
          end
        end

        i += 1
        i = 0 if i == 3

      else
        started = true

        if paddle_pos[0] > ball_pos[0] && paddle_pos[1] - ball_pos[1] > 0
          -1
        elsif paddle_pos[0] < ball_pos[0] && paddle_pos[1] - ball_pos[1] > 0
          1
        else
          0
        end
      end

    end

    self
  end

  def render
    @tiles.compact.map{ |r| r.map{ |t| get_tile_output(t) }.join }.join("\n")
  end

  def get_tile_output(t)
    case t
    when Tile::EMPTY
      "  "
    when Tile::WALL
      "🧱"
    when Tile::BLOCK
      "👾"
    when Tile::PADDLE
      "🚀"
    when Tile::BALL
      "⚡️"
    end
  end

end

start = Time.now
arcade = Arcade.new(input).run!
part1 = arcade.tiles.flatten.select{ |t| t == Tile::BLOCK }.size
puts "Part 1: #{part1} (#{Time.now - start}s)"
puts arcade.render

start = Time.now
part2 = Arcade.new(input).run!(2, ARGV[0] == "vis").score
puts "Part 2: #{part2} (#{Time.now - start}s)"