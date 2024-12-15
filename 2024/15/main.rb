require_relative '../util/time'
require_relative '../util/grid'

DIR_L, DIR_U = [-1,0], [0,-1]
DIR_R, DIR_D = [1,0], [0,1]
DIRS = {
  "<" => DIR_L, "^" => DIR_U,
  ">" => DIR_R, "v" => DIR_D
}

class Warehouse < Grid

  def d(c, d)
    [c[0] + d[0], c[1] + d[1]]
  end

  def dx(c, d)
    [c[0] + d, c[1]]
  end

  def move_robot(from, to)
    self[from] = "."
    self[to] = "@"
    to
  end

  def push(box, dir)
    first = box
    while gi = self[box]
      case gi
      when "#"; return false
      when "."; break
      end
      box = self.d(box, dir)
    end

    self[first] = "."
    self[box] = "O"
    true
  end

  def gpsc(type)
    self.select(type).sum{ _1 + 100*_2 }
  end

end

class DoubleWideWarehouse < Warehouse

  def initialize(rows)
    rows = rows.map do |r|
      r.zip(r).map! do |a|
        a = ["@","."] if a.first == "@"
        a = ["[","]"] if a.first == "O"
        a
      end.flatten
    end
    super(rows)
  end

  def push(box, dir)
    boxes = self.collect_push(box, dir)
    boxes.each do |bc|
      self[bc] = self[bc.first + 1, bc.last] = "."
      bcn = self.d(bc, dir)
      self[bcn] = "["
      self[bcn.first + 1, bcn.last] = "]"
    end
    boxes.any?
  end

  private

  def collect_push(box, dir)
    boxes = []

    # Vertical
    if dir.first == 0
      check_l = self.d(box, dir)
      check_r = self.dx(check_l, 1)
      l, r = self[check_l], self[check_r]

      if l == "." && r == "."
        boxes << box
      elsif l != "#" && r != "#"
        if l != "."
          pushed_l = self.collect_push(l == "[" ? check_l : self.dx(check_l, -1), dir)
          pushed_l.empty? ? (return []) : boxes += pushed_l
        end
        if r == "["
          pushed_r = self.collect_push(check_r, dir)
          pushed_r.empty? ? (return []) : boxes += pushed_r
        end

        boxes << box
        boxes.uniq!
      end

    # Horizontal
    else
      check = self.dx(box, dir == DIR_L ? -1 : 2)
      gi = self[check]

      if gi == "."
        boxes << box
      elsif gi != "#"
        check = self.d(check, dir) if dir == DIR_L
        boxes = self.collect_push(check, dir)
        boxes << box if boxes.any?
      end
    end

    boxes
  end

end

def prep
  input = File.read("input", chomp: true).split("\n\n")
    .map{ _1.split("\n").map(&:chars) }
  [input.first, input.last.flatten]
end

def part1(rows, moves)
  grid = Warehouse.new(rows)
  r = grid.detect("@")

  moves.each do |m|
    dir = DIRS[m]
    check = grid.d(r, dir)
    gi = grid[check]

    if gi == "." || (gi == "O" && grid.push(check, dir))
      r = grid.move_robot(r, check)
    end
  end

  grid.gpsc("O")
end

def part2(rows, moves)
  grid = DoubleWideWarehouse.new(rows)
  r = grid.detect("@")

  moves.each do |m|
    dir = DIRS[m]
    check = grid.d(r, dir)
    gi = grid[check]

    if gi == "[" || gi == "]"
      bc = gi == "]" ? grid.d(check, DIR_L) : check
      boxes_moved = grid.push(bc, dir)
    end
    r = grid.move_robot(r, check) if gi == "." || boxes_moved
  end

  grid.gpsc("[")
end

rows, moves = time("Prep", false){ prep }
time("Part 1"){ part1(rows.map(&:clone), moves) }
time("Part 2"){ part2(rows, moves) }