data = File.read("input")
# data = "^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$"
# data = "^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$"
# data = "^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$"
# data = "^ENWWW(NEEE|SSE(EE|N))$"

data = data[1..-2]

class Area

  attr_reader :area, :width, :height
  def initialize(area)
    @area = area
  end

  def extend_n!(x,y)
    ext_y = 0
    if at_n_edge?(x, y)
      empties = " " * @area.first.size
      @area.unshift(empties, empties.dup)
      ext_y = 2
      y += 2
    end

    existing_room = @area[y - 2][x] == '.'

    @area[y - 2][x - 1] = '?' unless @area[y - 2][x - 1] == '|'
    @area[y - 2][x] = '.' unless existing_room
    @area[y - 2][x + 1] = '?' unless @area[y - 2][x + 1] == '|'
    @area[y - 3][x - 1] = '#'
    @area[y - 3][x] = '?' unless @area[y - 3][x] == '-'
    @area[y - 3][x + 1] = '#'
    
    @area[y - 1][x] = '-'
    [x, y - 2, 0, ext_y, existing_room]
  end

  def extend_e!(x, y)
    @area.each{ |r|  r.concat("  ") } if at_e_edge?(x, y)

    existing_room = @area[y][x + 2] == '.'

    @area[y - 1][x + 2] = '?' unless @area[y - 1][x + 2] == '-'
    @area[y][x + 2] = '.' unless existing_room
    @area[y + 1][x + 2] = '?' unless @area[y + 1][x + 2] == '-'
    @area[y - 1][x + 3] = '#'
    @area[y][x + 3] = '?' unless @area[y][x + 3] == '|'
    @area[y + 1][x + 3] = '#'

    @area[y][x + 1] = '|'
    [x + 2, y, 0, 0, existing_room]
  end

  def extend_s!(x,y)
    if at_s_edge?(x, y)
      empties = " " * @area.first.size
      @area.push(empties, empties.dup)
    end

    existing_room = @area[y + 2][x] == '.'

    @area[y + 2][x - 1] = '?' unless @area[y + 2][x - 1] == '|'
    @area[y + 2][x] = '.' unless existing_room
    @area[y + 2][x + 1] = '?' unless @area[y + 2][x + 1] == '|'
    @area[y + 3][x - 1] = '#'
    @area[y + 3][x] = '?' unless @area[y + 3][x] == '-'
    @area[y + 3][x + 1] = '#'
    
    @area[y + 1][x] = '-'
    [x, y + 2, 0, 0, existing_room]
  end

  def extend_w!(x, y)
    ext_x = 0
    if at_w_edge?(x, y)
      @area.each{ |r|  r.prepend("  ") }
      ext_x = 2
      x += 2
    end

    existing_room = @area[y][x - 2] == '.'

    @area[y - 1][x - 2] = '?' unless @area[y - 1][x - 2] == '-'
    @area[y][x - 2] = '.' unless existing_room
    @area[y + 1][x - 2] = '?' unless @area[y + 1][x - 2] == '-'
    @area[y - 1][x - 3] = '#'
    @area[y][x - 3] = '?' unless @area[y][x - 3] == '|'
    @area[y + 1][x - 3] = '#'
    
    @area[y][x - 1] = '|'
    [x - 2, y, ext_x, 0, existing_room]
  end

  def at_n_edge?(x, y)
    y == 1
  end

  def at_e_edge?(x, y)
    x == area.first.size - 2
  end

  def at_s_edge?(x, y)
    y == area.size - 2
  end

  def at_w_edge?(x, y)
    x == 1
  end

  def to_s(pretty = false)
    pretty ? @area.map{ |r| r.gsub(/[.|-]/, ' ').gsub('#', '█') }.join("\n") : @area.join("\n")
  end

  def unknown_to_wall!
    @area.each{ |r| r.gsub!('?', '#') }
  end

end

area = Area.new("#?#?X?#?#".chars.each_slice(3).map(&:join))

def find_closing_bracket(path, open_idx)
  close_idx = open_idx
  c = 1

  while c > 0 do
    close_idx += 1
    case path[close_idx]
    when '('
      c += 1
    when ')'
      c -= 1
    end
  end

  close_idx
end

$paths = []
$DEBUG = false
def build(area, path, x, y, steps)
  pointer = 0
  start_x, start_y = x, y
  ext_x, ext_y = 0, 0
  start_steps = steps

  puts path if $DEBUG

  while pointer < path.size do

    item = path[pointer]
    puts "#{path} #{pointer} #{item}" if $DEBUG

    case item
    when '('
      branch_end = find_closing_bracket(path, pointer)
      x, y = build(area, path[pointer+1...branch_end], x, y, steps)
      pointer = branch_end
    when ')'
      pointer += 1
      $paths << steps
      steps = start_steps
    when '|'
      x, y = start_x + ext_x, start_y + ext_y
      $paths << steps
      steps = start_steps
      puts "#{start_x} #{start_y} #{ext_x} #{ext_y}" if $DEBUG
    else
      x, y, e_x, e_y, existing_room = area.send("extend_#{item.downcase}!", x, y)
      ext_x += e_x
      ext_y += e_y
      steps += 1 unless existing_room
    end
    
    puts area if $DEBUG
    pointer += 1
  end

  $paths << steps

  # $DEBUG = true if pointer == 10221 && x == 89 && y == 5
  # $DEBUG = false if pointer == 6 && x == 107 && y == 17

  [x, y]
end


build(area, data, 1, 1, 0)
area.unknown_to_wall!
puts area

puts "Part 1: #{$paths.max}"
# p $paths.count{ |p| p >= 1000 }