require_relative 'astar'

class Cave

  attr_reader :goblins, :elves

  def initialize(cavearr, elf_attack_power = 3)
    @elves = []
    @goblins = []

    @cave = cavearr.each_with_index.map do |row,y|
      row.each_with_index.map do |caveitem,x|
        case caveitem
        when '#'
          Wall.new(x,y)
        when 'G'
          g = Goblin.new(x,y)
          @goblins << g
          g
        when 'E'
          e = Elf.new(x,y,elf_attack_power)
          @elves << e
          e
        when '.'
          Void.new(x,y)
        end
      end
    end
  end

  def [](x, y)
    @cave[y] ? @cave[y][x] : nil
  end

  def []=(x,y,caveitem)
    @cave[y][x] = caveitem
  end

  def round!(step = false)
    @cave.flatten.select{ |ci| ci.is_a?(Unit) }.each_with_index do |unit,i|
      # Find Targets
      targets = targets(unit)

      # Next if dead
      next if unit.is_dead?

      # Done if no targets
      return true if targets.empty?

      # Find adjecent targets
      adjecent_targets = targets & adjecent(unit)

      # Move if there are none
      if adjecent_targets.empty?

        # Find empty squares adjecent to targets
        squares = targets
          .map{ |t| adjecent(t) }
          .flatten
          .select{ |u| u.is_a?(Void) }

        # End move if there are no target squares
        next if squares.empty?

        # Find shortest path, sorted by reading order
        path = squares
          .map{ |s| astar(self, unit, s) }
          .compact
          .sort_by{ |p| [p.size, p[-1].y, p[-1].x] }
          .first

        # No paths possible to any of the squares
        next if path.nil?

        # Check all adjecent voids, see if path from that
        # void is equal to shortest path, then select
        # new pos based on reading order.
        new_pos = adjecent(unit)
          .select{ |u| u.is_a?(Void) }
          .map{ |v| astar(self, v, path.last) }
          .compact
          .select{ |p| p.size == path.length - 1}
          .sort_by{ |p| [p.first.y, p.first.x] }
          .first
          .first
        
        # Move it
        move(unit, new_pos)
      end

      # Find adjecent targets again
      adjecent_targets = targets & adjecent(unit)

      # If we have an adjecent target, we can attack!
      if adjecent_targets.any?

        # Find target
        target = adjecent_targets.sort_by{ |t| [t.hit_points, t.y, t.x] }.first

        # Attack
        attack!(unit, target)
      end

    end

    false

  end

  def targets(unit)
    case
    when unit.is_a?(Elf)
      @goblins.select{ |g| !g.is_dead? }
    when unit.is_a?(Goblin)
      @elves.select{ |e| !e.is_dead? }
    else
      []
    end
  end

  def adjecent(unit)
    [
      self[unit.x,unit.y-1],
      self[unit.x-1,unit.y],
      self[unit.x+1,unit.y],
      self[unit.x,unit.y+1]
    ].compact
  end

  def position(unit)
    idx = @cave.flatten.index(unit)
    [idx % @cave.size, (idx / @cave.size).to_i]
  end

  def width
    @cave.first.size
  end

  def move(unit, to_caveitem)
    # puts "#{unit.icon} @ (#{unit.x},#{unit.y}) Moves to (#{to_caveitem.x},#{to_caveitem.y})"
    self[unit.x, unit.y] = Void.new(unit.x, unit.y)
    self[to_caveitem.x, to_caveitem.y] = unit
    unit.move_to(to_caveitem.x, to_caveitem.y)
  end

  def attack!(attacker, target)
    # puts "#{attacker.icon} @ (#{attacker.x},#{attacker.y}) Attacks #{target.icon} @ (#{target.x},#{target.y})"
    attacker.attack!(target)
    self[target.x,target.y] = Void.new(target.x, target.y) if target.is_dead?
  end

  def to_s
    @cave.map{ |row| row.map{ |ci| ci.icon }.join('') }.join("\n")
  end

  def puts_units
    @cave.flatten.select{ |ci| ci.is_a?(Unit) }.each do |unit|
      puts unit
    end
  end

  def remaining_hit_points
    (@goblins + @elves).select{ |u| !u.is_dead? }.sum(&:hit_points)
  end

  def goblins_won?
    @elves.select{ |u| !u.is_dead? }.empty?
  end

  def elves_won?
    @goblins.select{ |u| !u.is_dead? }.empty?
  end

  def dead_elves
    @elves.select(&:is_dead?)
  end

end

class CaveItem

  attr_reader :x, :y

  def initialize(x,y)
    move_to(x,y)
  end

  def distance_to(other)
    (other.x - @x).abs + (other.y - @y).abs
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

  def move_to(x,y)
    @x = x
    @y = y
  end

  def to_s
    "#{self.class} @ (#{@x}, #{@y})"
  end

end

class Wall < CaveItem
  def icon
    '#'
  end
end

class Void < CaveItem
  def icon
    '.'
  end
end

class Unit < CaveItem

  attr_reader :attack_power, :hit_points

  def initialize(x,y)
    super(x,y)
    @attack_power = 3
    @hit_points = 200
  end

  def attack!(target)
    target.damage!(self)
  end

  def damage!(attacker)
    @hit_points -= attacker.attack_power
  end

  def is_dead?
    @hit_points <= 0
  end

  def to_s
    "#{icon} @ (#{@x},#{@y}), HP: #{@hit_points}"
  end

end

class Elf < Unit
  def initialize(x,y,attack_power)
    super(x,y)
    @attack_power = attack_power
  end
  def icon
    'E'
  end
end

class Goblin < Unit
  def icon
    'G'
  end
end

data = File.readlines("input").map{ |l| l.chomp.split('') }
cave = Cave.new(data)

1.step do |round|
  if cave.round!
    part1 = (round - 1) * cave.remaining_hit_points
    puts "Part 1: #{part1}"
    break
  end
end

part2 = nil
4.step do |ap|
  cave = Cave.new(data, ap)
  1.step do |round|
    if cave.round!
      outcome = (round - 1) * cave.remaining_hit_points
      if cave.elves_won? && cave.dead_elves.empty?
        part2 = (round - 1) * cave.remaining_hit_points
        puts "Part 2: #{part2}"
      end
      break
    end
  end
  break if part2
end