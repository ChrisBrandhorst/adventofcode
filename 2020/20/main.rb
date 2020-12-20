class Tile

  TOP = 0
  RIGHT = 1
  BOTTOM = 2
  LEFT = 3

  FILLED = '#'
  EMPTY = '.'

  attr_reader :id, :code, :grid

  def initialize(lines)
    parts = lines.split("\n")
    @id = parts.shift.sub(/Tile (\d+):/, '\1').to_i
    @grid = parts.map{ |l| l.split('').map{ |c| c == FILLED ? 1 : 0 } }
    generate_code
  end

  def top; @grid.first.join(''); end
  def right; @grid.map{ |g| g.last }.join(''); end
  def bottom; @grid.last.join(''); end
  def left; @grid.map{ |g| g.first }.join(''); end

  def generate_code
    @code = [top, right, bottom, left].map{ |s| [s.to_i(2), s.reverse.to_i(2)].max }
  end

  def flip_hor!
    @grid.reverse!
    top = @code[TOP]
    @code[TOP] = @code[BOTTOM]
    @code[BOTTOM] = top
    self
  end

  def flip_vert!
    @grid.each(&:reverse!)
    right = @code[RIGHT]
    @code[RIGHT] = @code[LEFT]
    @code[LEFT] = right
    self
  end

  def rotate!(times = 1)
    times.times do
      @grid = @grid.transpose.map(&:reverse)
      @code.unshift(@code.pop)
    end
    self
  end

  def size
    @grid.first.size
  end

  def to_s
    @grid.map{ |l| l.join('').gsub('1', FILLED).gsub('0', EMPTY) }.join("\n") + "\n\n"
  end

end

class Image
  attr_reader :assembly, :lines

  def initialize(tiles)
    @tiles = tiles.clone
  end

  def code_count
    @code_count ||= @tiles.map{ |t| t.code }.flatten.inject(Hash.new(0)) { |total, e| total[e] += 1 ;total }
  end

  def edge_codes
    @edge_codes ||= code_count.select{ |k,v| v == 1 }.keys
  end

  def corners
    @corners ||= @tiles.select{ |t| (t.code & edge_codes).size == 2 }
  end

  def assemble!
    @assembly, remaining, s = [], @tiles.clone, size

    s.times do |r|
      tiles_row = []
      s.times do |c|
        if tiles_row.empty?
          # Fill leftmost
          if r == 0
            # Get random first corner for left-top
            tile = corners.first
            tile.rotate!( 3 - tile.code.index((tile.code & edge_codes).first) )
          else
            # Find matching above
            above = @assembly[r - 1][c]
            above_code = above.code[Tile::BOTTOM]
            tile = remaining.find{ |t| t.code.include?(above_code) }
            ri = tile.code.index(above_code)
            tile.rotate!( 4 - ri ) if ri > 0
            tile.flip_vert! if above.bottom != tile.top
          end
        else
          # Find matching left (and above if first row)
          left = tiles_row[c - 1]
          left_code = left.code[Tile::RIGHT]
          left_tiles = remaining.select{ |t| t.code.include?(left_code) }
          tile = r > 0 ? left_tiles.find{ |t| t.code.include?(@assembly[r - 1][c].code[Tile::BOTTOM]) } : left_tiles.first
          tile.rotate!( 3 - tile.code.index(left_code) )
          tile.flip_hor! if left.right != tile.left
        end
        remaining.delete(tile)
        tiles_row << tile
      end
      @assembly << tiles_row
    end
    self
  end

  def build_lines!
    @lines = @assembly.inject([]) do |ib,r|
      (1...@tiles.first.size-1).each do |w|
        ib << r.map{ |c| c.grid[w][1...@tiles.first.size-1] }.flatten.join('').gsub('0', Tile::EMPTY).gsub('1', Tile::FILLED)
      end
      ib
    end
    self
  end

  def flip_hor!
    @assembly.reverse!
  end

  def flip_vert!
    @assembly.each{ |a| a.reverse! }
  end

  def rotate!(times = 1)
    times.times{ @assembly = @assembly.transpose.map(&:reverse) }
  end

  def to_s
    @lines.join("\n")
  end

  def size
    Math.sqrt(@tiles.size).to_i
  end

  def roughness
    monster = Monster.new
    waves = to_s.count(Tile::FILLED)
    monsters = lines.each_with_index.inject(0) do |c,(r,i)|
      r.scan(monster.matchers[1]).inject(c) do |cf,f|
        mi = $~.offset(0).first
        top_match = !!(lines[i - 1][mi, monster.width] =~ monster.matchers[0])
        bottom_match = !!(lines[i + 1][mi, monster.width] =~ monster.matchers[2])
        top_match && bottom_match ? cf+ 1 : cf
      end
    end
    waves - monsters * monster.surface
  end

end

class Monster
  DEFINITION = "                  # \n#    ##    ##    ###\n #  #  #  #  #  #   "
  attr_reader :parts, :width, :surface, :matchers
  def initialize
    @parts = DEFINITION.split("\n")
    @width = @parts.first.size
    @surface = DEFINITION.count(Tile::FILLED)
    @matchers = parts.map{ |p| Regexp.new( "(?=(" + p.gsub(' ', '.') + "))" ) }
  end
end

start = Time.now
input = File.read("input").split("\n\n").map{ |i| Tile.new(i) }
image = Image.new( input )
puts "Prep:   #{Time.now - start}s"

start1 = Time.now
part1 = image.corners.map(&:id).inject(&:*)
puts "Part 1: #{part1} (#{Time.now - start1}s)"

start2 = Time.now
part2 = image.assemble!.build_lines!.roughness
puts "Part 2: #{part2} (#{Time.now - start2}s)"

puts "Total:  #{Time.now - start}s"

puts image