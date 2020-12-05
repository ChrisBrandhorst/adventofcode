require '../intcode/intcode'

input = File.read("input").split(",").map(&:to_i)

class VacuumRobot

  EMPTY = '.'
  SCAFFOLD = '#'

  def initialize(input)
    @start_pos = nil
    @input = input
  end

  def build_grid!
    @grid = [[]]
    Intcode.new(@input).run do |op,out|
      if out.chr == "\n"
        @grid << []
      else
        @grid.last << out.chr
        @start_pos = { x: @grid.last.size - 1, y: @grid.size - 1 } if @start_pos.nil? && ![EMPTY,SCAFFOLD].include?(out.chr)
      end
    end
    self
  end

  def intersections
    ret = []
    (0..@grid.size-1).each do |y|
      (0..@grid[y].size-1).each do |x|
        adj = adjecent(x, y).uniq
        ret << [x,y] if @grid[y][x] == SCAFFOLD && adj.size == 1 && adj.first == SCAFFOLD
      end
    end
    ret
  end

  def adjecent(x, y)
    [
      y == 0 ? EMPTY : @grid[y-1][x],
      @grid[y][x+1] || EMPTY,
      @grid[y+1][x] || EMPTY,
      x == 0 ? EMPTY : @grid[y][x-1]
    ]
  end

  def render
    @grid.map{ |r| r.join }.join("\n")
  end

  def path
    x = @start_pos[:x]
    y = @start_pos[:y]
    dir = 0
    path_arr = []
    
    while true do
      adj = adjecent(x, y)
      break if adj.select{ |a| a != EMPTY }.size == 1 && path_arr.any?

      if adj[dir] == SCAFFOLD
        path_arr.last[1] += 1
      elsif adj[dir-1] == SCAFFOLD
        dir = dir == 0 ? 3 : dir - 1
        path_arr << ['L', 1]
      else
        dir = dir == 3 ? 0 : dir + 1
        path_arr << ['R', 1]
      end

      case dir
      when 0; y -= 1
      when 1; x += 1
      when 2; y += 1
      when 3; x -= 1
      end

    end
    path_arr
  end

  def self.build_functions(path_arr)
    path_str = path_arr.flatten.join("")

    functions = []
    until path_str.empty?
      f = ""
      loop do
        first = path_str[/^\w\d+/]
        if path_str.scan(f + first).size >= 2
          f += path_str.slice!(0,first.size)
        else
          break
        end
      end

      if f.empty?
        functions << path_str
        break
      else
        functions << f
        path_str.gsub!(f, "")
      end
    end

    functions = functions
      .each_with_index.map{ |f,i| [(i + "A".ord).chr, f] }
      .sort_by{ |f| f.first.size }

    functions.each do |f|
      functions.each do |f2|
        next if f == f2
        f2.last.gsub!(f.last, "")
      end
    end

    functions.sort_by{ |f| f.first }
  end

  def self.build_main(path_arr, functions)
    main = path_arr.flatten.join("")
    functions.each do |f|
      main.gsub!(f[1], f[0])
    end
    main
  end

  def search!
    path_arr = path

    functions = VacuumRobot::build_functions(path_arr)
    main = VacuumRobot::build_main(path_arr, functions)

    inp = main.split("").join(",").split("").map(&:ord)
    inp << "\n".ord
    functions.each do |f|
      f.last.gsub(/([LR]|\d+)(?!$)/, "\\1,").split("").each{ |c| inp << c.ord }
      inp << "\n".ord
    end
    inp << "n".ord
    inp << "\n".ord

    intcode = Intcode.new(@input)
    intcode[0] = 2

    ret = nil
    intcode.run do |op,out|
      ret = out
      inp.shift if op == :in
    end
    ret
  end

end

start = Time.now
vacuum_robot = VacuumRobot.new(input).build_grid!
part1 = vacuum_robot.intersections.sum{ |i| i[1] * i[0] }
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = vacuum_robot.search!
puts "Part 2: #{part2} (#{Time.now - start}s)"