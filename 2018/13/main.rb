data = File.readlines("input")

class Track

  attr_reader :carts

  def initialize(data)
    @data = data
    @carts = []
    @data.each_with_index do |l,y|
      l.chars.each_with_index do |c,x|
        d = "^>v<".index(c)
        if !d.nil?
          cart = Cart.new(x, y, d, self)
          @carts << cart
          @data[y][x] = (cart.up? || cart.down?) ? '|' : '-'
        end
      end
    end
  end

  def section(x, y)
    @data[y][x]
  end

  def to_s
    @carts.map{ |c| "#{c.x},#{c.y}" }
  end

  def has_collision?
    @carts.uniq{ |c| [c.x, c.y] }.size < @carts.size
  end

  def collisions
    @carts - @carts.uniq{ |c| [c.x, c.y] }
  end

  def collide!
    deleted = []
    collided = collisions.first
    return deleted if collided.nil?

    @carts.clone.each do |c|
      deleted << @carts.delete(c) if c.collides_with?(collided)
    end
    deleted
  end

  def sort!
    @carts.sort!
  end

  def to_s
    output = Marshal.load( Marshal.dump(@data) )
    @carts.each do |c|
      output[c.y][c.x] = '█'
    end
    output.join('')
  end

  def remove_cart(cart)
    @carts.delete(cart)
  end

end

class Cart

  attr_reader :x, :y, :dir

  UP = 0
  RIGHT = 1
  DOWN = 2
  LEFT = 3

  def initialize(x, y, dir, track)
    @x = x
    @y = y
    @dir = dir
    @track = track
    @next_turn = -1
  end

  def index
    @track.carts.index(self)
  end

  def up?; @dir == UP; end
  def right?; @dir == RIGHT; end
  def down?; @dir == DOWN; end
  def left?; @dir == LEFT; end

  def up!; @dir = UP; end
  def down!; @dir = DOWN; end
  def left!; @dir = LEFT; end
  def right!; @dir = RIGHT; end

  def next_y
    up? ? @y - 1 : down? ? @y + 1 : @y
  end

  def next_x
    left? ? @x - 1 : right? ? @x + 1 : @x
  end

  def move!
    nxt = @track.section(next_x, next_y)
    @x = next_x
    @y = next_y
    
    if nxt == '/'
      if up?;       right!
      elsif left?;  down!
      elsif right?; up!
      elsif down?;  left!
      end
    elsif nxt == '\\'
      if right?;    down!
      elsif up?;    left!
      elsif down?;  right!
      elsif left?;  up!
      end
    elsif nxt == '+'
      @dir += @next_turn
      @dir = LEFT if @dir == -1
      @dir = UP if @dir == 4
      @next_turn += 1
      @next_turn = -1 if @next_turn == 2
    else
      # Go on
    end

  end

  def collides_with?(o)
    @x == o.x && @y == o.y
  end

  def <=>(o)
    if @y < o.y
      -1
    elsif @y == o.y
      @x <=> o.x
    else
      1
    end
  end

end


track = Track.new(data)
first_collision = nil
loop do
  track.sort!
  track.carts.clone.each do |c|
    c.move!
    gone = track.collide!
    if gone.any? && first_collision.nil?
      first_collision = gone.first
      puts "Part 1: #{first_collision.x},#{first_collision.y}"
    end
  end
  break if track.carts.size <= 1
end

cart = track.carts.first
puts "Part 2: #{cart.x},#{cart.y}"