require_relative '../util/time'

def prep
  File.read("input", chomp: true).chars.map(&:to_i)
end

class Disk
  attr_reader :blocks, :files, :spaces

  def initialize(input)
    @blocks = input.each_with_index.map{ |c,i| Block.new(c, i.even? ? i/2 : nil) }
    @files, @spaces = blocks.partition.with_index{ |_,i| i.even? }
  end

  def checksum
    sum = 0
    i = 0
    @blocks.each do |b|
      sum += b.contents.each_with_index.sum{ |v,i2| (i2+i) * v }
      i += b.size
    end
    sum
  end

end

class Block
  attr_reader :value, :size, :contents

  def initialize(c, v = nil)
    @size = c
    if v
      @value = v
      @contents = [v] * c
    else
      @contents = []
    end
  end

  def empty!(remain = 0)
    @contents = remain == 0 ? [] : [@value] * remain
  end

  def full?
    @contents.size == @size
  end

  def remaining
    @size - @contents.size
  end

  def write!(file)
    c, v, r = file.contents.size, file.value, self.remaining
    if c <= r
      @contents += [v] * c
      0
    else
      @contents += [v] * r
      c - r
    end
  end

end

def part1(input)
  disk = Disk.new(input)
  files, spaces = disk.files, disk.spaces

  fi = files.size - 1
  spaces.each.with_index do |s, si|
    break if fi <= si
    until s.full?
      f = files[fi]
      remaining = s.write!(f)
      f.empty!(remaining)
      fi -= 1 if remaining == 0
    end
  end

  disk.checksum
end

def part2(input)
  disk = Disk.new(input)
  files, spaces = disk.files, disk.spaces

  files.to_enum.with_index.reverse_each do |f, fi|
    (0...fi).step(1) do |si|
      if spaces[si].remaining >= f.size
        spaces[si].write!(f)
        f.empty!
        break
      end
    end
  end

  disk.checksum
end

input = time("Prep", false){ prep }
time("Part 1"){ part1(input) }
time("Part 2"){ part2(input) }