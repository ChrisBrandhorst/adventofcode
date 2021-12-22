class Cuboid

  attr_reader :x, :y, :z
  attr_reader :xa, :xb, :ya, :yb, :za, :zb

  def self::from_input(xa, xb, ya, yb, za, zb)
    Cuboid.new(xa, xb + 1, ya, yb + 1, za, zb + 1)
  end

  def initialize(xa, xb, ya, yb, za, zb)
    @xa = xa; @xb = xb
    @ya = ya; @yb = yb
    @za = za; @zb = zb
  end

  def size
    (@xb - @xa) * (@yb - @ya) * (@zb - @za)
  end

  def overlaps?(other)
    [@xa, other.xa].max < [@xb, other.xb].min &&
    [@ya, other.ya].max < [@yb, other.yb].min &&
    [@za, other.za].max < [@zb, other.zb].min
  end

  def dice(other)
    return nil unless self.overlaps?(other)
    pieces = []
    x_points = [@xa, @xb, other.xa, other.xb].uniq.sort
    y_points = [@ya, @yb, other.ya, other.yb].uniq.sort
    z_points = [@za, @zb, other.za, other.zb].uniq.sort
    x_points.each_cons(2).each do |xa, xb|
      y_points.each_cons(2).each do |ya, yb|
        z_points.each_cons(2).each do |za, zb|
          piece = Cuboid.new(xa, xb, ya, yb, za, zb)
          pieces << piece if piece.overlaps?(self) && !piece.overlaps?(other)
        end
      end
    end
    pieces
  end

end


start = Time.now
input = File.readlines("input", chomp: true).map{ |l| r = l.split; [r.first, r.last.scan(/[-\d]+/).map(&:to_i)] }

world = []
input.map{ |op,cs| [op, Cuboid.from_input(*cs)] }.each do |op,c|
  new_world = op == "on" ? [c] : []
  world.each do |o|
    pieces = o.dice(c)
    if pieces.nil?
      new_world << o
    else
      new_world += pieces
    end
  end
  world = new_world
end

puts "Prep: #{Time.now - start}s"


start = Time.now
init_region = Cuboid.from_input(*[-50,50]*3)
part1 = world.select{ |c| c.overlaps?(init_region) }.sum(&:size)
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = world.sum(&:size)
puts "Part 2: #{part2} (#{Time.now - start}s)"