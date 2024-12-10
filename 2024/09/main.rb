require_relative '../util/time'

def prep
  File.read("input", chomp: true).chars.map(&:to_i)
end

class Disk
  attr_reader :files, :spaces

  def initialize(input)
    @blocks = input.each_with_index.map{ |c,i| Block.new(c, i.even? ? i/2 : nil) }
    @files, @spaces = @blocks.partition.with_index{ |_,i| i.even? }
  end

  def checksum
    sum = 0
    i = 0
    @blocks.each do |b|
      sum += b.contents.each_with_index.sum{ |v,d| (i+d) * v }
      i += b.size
    end
    sum
  end

  def move!(file, space)
    unwritten = space.write!(file)
    file.clear!(unwritten)
    unwritten
  end

end

class Block
  attr_reader :size, :value, :contents

  def initialize(size, value = nil)
    @size = size
    if value
      @value = value
      @contents = [value] * size
    else
      @contents = []
    end
  end

  def remaining
    @size - @contents.size
  end

  def write!(file)
    size, value, remaining = file.contents.size, file.value, self.remaining
    if size <= remaining
      @contents += [value] * size
      0
    else
      @contents += [value] * remaining
      size - remaining
    end
  end

  def clear!(keep = 0)
    @contents = keep == 0 ? [] : [@value] * keep
  end

end

def part1(input)
  disk = Disk.new(input)
  files = disk.files

  fi = files.size - 1
  disk.spaces.each.with_index do |space, si|
    until space.remaining == 0
      break if fi <= si
      fi -= 1 if disk.move!(files[fi], space) == 0
    end
  end

  disk.checksum
end

def part2(input)
  disk = Disk.new(input)

  disk.files.to_enum.with_index.reverse_each do |file, fi|
    disk.spaces[0...fi].each do |space|
      if space.remaining >= file.size
        disk.move!(file, space)
        break
      end
    end
  end

  disk.checksum
end

input = time("Prep", false){ prep }
time("Part 1"){ part1(input) }
time("Part 2"){ part2(input) }