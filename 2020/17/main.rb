start = Time.now
input = File.readlines("input", chomp: true)
  .map{ |l| l.split('') }

input = {
  0 => {
    0 => input.map.with_index{ |xs,x|
      [ x, xs.map.with_index{ |x,i| [i,x] }.to_h ]
    }.to_h
  }
}
puts "Prep:   #{Time.now - start}s"

INACTIVE = '.'
ACTIVE = '#'

class Grid

  attr_reader :grid

  def initialize(grid)
    @grid = grid
  end

  def get(x, y, z, w)
    @grid[w] && @grid[w][z] && @grid[w][z][y] ? @grid[w][z][y][x] || INACTIVE : INACTIVE
  end
  alias_method :[], :get

  def adjecent_plane(x, y, z, w, center = true)
    adj = [
      get(x + 1, y, z, w),
      get(x, y + 1, z, w),
      get(x + 1, y + 1, z, w),
      get(x - 1, y - 1, z, w),
      get(x, y - 1, z, w),
      get(x + 1, y - 1, z, w),
      get(x - 1, y, z, w),
      get(x - 1, y + 1, z, w),
      get(x, y, z, w)
    ]
    adj
  end

  def adjecent_cube(x, y, z, w)
    [
      adjecent_plane(x, y, z - 1, w),
      adjecent_plane(x, y, z, w, false),
      adjecent_plane(x, y, z + 1, w)
    ]
  end

  def adjecent(x, y, z, w, fourd = false)
    adj = [
      fourd ? adjecent_cube(x, y, z, w - 1) : [],
      adjecent_cube(x, y, z, w),
      fourd ? adjecent_cube(x, y, z, w + 1) : []
    ].flatten

    i = adj.index( get(x, y, z, w) )
    adj.delete_at(i)

    adj
  end

  # def adjecent(x, y, z, w, fourd = false)
  #   dims = fourd ? 4 : 3
    
  #   adj = []
  #   [-1,0,1].repeated_permutation(dims).each do |ds|
  #     next if ds.count(0) == ds.size
  #     adj << get( *[x, y, z, w].zip(ds).map(&:sum) )
  #   end

  #   adj
  # end

  def to_s
    @grid.map{ |w,gw|
      gw.map{ |z,gz|
        "z=#{z}, w=#{w}\n" + 
        gz.values.map{ |gy| gy.values.join }.join("\n")
      }
    }.join("\n-------\n")
  end

  def count(i)
    @grid.values.map{ |gw|
      gw.values.map{ |gy|
        gy.values.map{ |gx|
          gx.values
        }
      }
    }.flatten.count(i)
  end

  def evolve!(fourd = false)
    min_w, max_w = fourd ? [@grid.keys.min - 1, @grid.keys.max + 1] : [0,0]
    min_z, max_z = @grid[0].keys.min - 1, @grid[0].keys.max + 1
    min, max = @grid[0][0].keys.min - 1, @grid[0][0].keys.max + 1
    new_grid = {}

    (min_w..max_w).each do |w|
      new_grid[w] = {}
      (min_z..max_z).each do |z|
        new_grid[w][z] = {}
        (min..max).each do |y|
          new_grid[w][z][y] = {}
          (min..max).each do |x|
            n = evolve_cube(x, y, z, w, fourd)
            new_grid[w][z][y][x] = n
          end
        end
      end
    end
    @grid = new_grid
  end

  def evolve_cube(x, y, z, w, fourd)
    cur = get(x, y, z, w)
    active = adjecent(x, y, z, w, fourd).count(ACTIVE)
    cur == ACTIVE && (active == 2 || active == 3) || cur == INACTIVE && active == 3 ? ACTIVE : INACTIVE
  end

end

start1 = Time.now
grid = Grid.new(input)
6.times do
  grid.evolve!
end
part1 = grid.count(ACTIVE)
puts "Part 1: #{part1} (#{Time.now - start1}s)"

start2 = Time.now
grid = Grid.new(input)
6.times do
  grid.evolve!(true)
end
part2 = grid.count(ACTIVE)
puts "Part 2: #{part2} (#{Time.now - start2}s)"

puts "Total:  #{Time.now - start}s"