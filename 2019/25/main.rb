require '../intcode/intcode'

input = File.read("input").split(",").map(&:to_i)

class Droid

  def initialize(input, commands)
    @intcode = Intcode.new(input)
    @command_buffer = (commands.join("\n") + "\n").split("").map{|c|c == '.' ? ' ' : c}.map(&:ord)
  end

  def run!
    out_buffer = []
    in_buffer = []

    @intcode.run do |op,out|
      Thread.pass
      if op == :out
        out_buffer << out
        if out == 10
          puts out_buffer.map(&:chr).join("")
          out_buffer = []
        end
      elsif @command_buffer.any?
        @command_buffer.shift
      else
        in_buffer = (gets).split("").map(&:ord) if in_buffer.empty?
        in_buffer.shift
      end
    end

  end

end

commands = %w{
  west
  take.cake
  west
  south
  take.monolith
  north
  west
  south
  east
  east
  east
  take.mug
  west
  west
  west
  north
  east
  east
  east
  south
  take.coin
  south
  west
  north
  north
  north
}

droid = Droid.new(input, commands)
droid.run!