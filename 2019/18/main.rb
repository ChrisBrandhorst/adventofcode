require './astar.rb'

class Vault

  attr_reader :keys, :doors, :you

  def initialize(vaultarr)
    @keys = []
    @doors = []

    @vault = vaultarr.each_with_index.map do |row,y|
      row.each_with_index.map do |vaultitem,x|
        case vaultitem
        when '#'
          Wall.new(x,y)
        when '.'
          Void.new(x,y)
        when '@'
          @you = You.new(x,y)
        else
          if vaultitem.match(/[a-z]/)
            key = Key.new(x,y,vaultitem)
            @keys << key
            key
          else
            door = Door.new(x,y,vaultitem)
            @doors << door
            door
          end
        end
      end
    end
  end

  def [](x, y)
    @vault[y] ? @vault[y][x] : nil
  end

  def []=(x,y,vaultitem)
    @vault[y][x] = vaultitem
  end

  def to_s
    @vault.map{ |row| row.map{ |ci| ci.icon }.join('') }.join("\n")
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
    idx = @vault.flatten.index(unit)
    [idx % @vault.size, (idx / @vault.size).to_i]
  end

  def width
    @vault.first.size
  end

  def move(unit, to_vaultitem)
    self[unit.x, unit.y] = Void.new(unit.x, unit.y)
    self[to_vaultitem.x, to_vaultitem.y] = unit
    unit.move_to(to_vaultitem.x, to_vaultitem.y)
  end

  def open!(door)
    self[door.x, door.y] = Void.new(door.x, door.y)
  end

  def neighbours(current, goal, keychain = [])
    adjecent(current).select do |u|
      !u.is_a?(Wall) && (
        u == goal || keychain == :all || !u.is_a?(Door) || u.opens_with?(keychain)
      )
    end
  end

  def path_to(from, to, keychain = [])
    astar(self, from, to, keychain)
  end

  def more_yous!
    yous = [
      You.new(@you.x - 1, @you.y - 1),
      You.new(@you.x + 1, @you.y - 1),
      You.new(@you.x - 1, @you.y + 1),
      You.new(@you.x + 1, @you.y + 1)
    ]
    walls = [
      Wall.new(@you.x, @you.y - 1),
      Wall.new(@you.x - 1, @you.y),
      Wall.new(@you.x, @you.y),
      Wall.new(@you.x + 1, @you.y),
      Wall.new(@you.x, @you.y + 1)
    ]
    (yous + walls).each{ |u| self[u.x,u.y]= u }

    yous
  end

end

class VaultItem

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

class You < VaultItem
  def icon
    '@'
  end
end

class Unit < VaultItem
  attr_reader :val
  def initialize(x,y,val)
    super(x,y)
    @val = val
  end
  def icon
    @val
  end
  def matches?(other)
    val == other.val
  end
end

class Key < Unit; def opens?(door); self.icon == door.icon.downcase; end; end
class Door < Unit
  def opens_with?(keys)
    if keys.is_a?(Array)
      keys.map(&:icon).include?(self.icon.downcase)
    else
      self.icon.downcase == keys.icon
    end
  end
end
class Void < VaultItem; def icon; '.'; end; end
class Wall < VaultItem; def icon; '#'; end; end


def key_paths(vault, extra_starts = [])
  key_paths = {}

  (extra_starts + vault.keys).each do |k|
    vault.keys.each do |k2|
      next if k == k2

      if key_paths[k2] && !key_paths[k2][k].nil?
        key_paths[k] ||= {}
        key_paths[k][k2] = key_paths[k2][k].reverse
        next
      end

      path = vault.path_to(k, k2, :all)
      if path
        key_paths[k] ||= {}
        key_paths[k][k2] = path
      end
    end
  end

  key_paths
end

def available_paths(current, paths, keychain)
  current_paths = paths[current] || {}
  current_paths.values.select do |p|
    !keychain.include?(p.last) && !p.any?{ |u| u.is_a?(Door) && !u.opens_with?(keychain) }
  end
end


def keys_distance(key_paths, currents, keychain, cache, targets)
  return 0 if keychain.size == targets.size
  
  cacheKey = currents.map(&:icon).sort.join("") + "-" + keychain.map(&:val).sort.join("")
  if cache.has_key?(cacheKey)
    return cache[cacheKey]
  end

  res = Float::INFINITY

  currents.each do |current|
    paths = available_paths(current, key_paths, keychain) || []

    paths.each do |p|
      new_currents = currents.clone
      new_currents[currents.index(current)] = p.last

      d = p.size - 1 + keys_distance(key_paths, new_currents, keychain + [p.last], cache, targets)
      res = [res, d].min
    end
  end

  cache[cacheKey] = res
  res
end

input = File.readlines("input").map{ |l| l.chomp.split('') }
vault = Vault.new(input)

start = Time.now
key_paths = key_paths(vault, [vault.you])
puts "Calculating all key-to-key paths: #{Time.now - start}s"
start = Time.now
part1 = keys_distance(key_paths, [vault.you], [], {}, vault.keys)
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
yous = vault.more_yous!
key_paths = key_paths(vault, yous)
puts "Calculating all key-to-key paths: #{Time.now - start}s"
part2 = keys_distance(key_paths, yous, [], {}, vault.keys)
puts "Part 2: #{part2} (#{Time.now - start}s)"