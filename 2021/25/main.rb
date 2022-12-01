require 'set'

class CucumberGrid

  def initialize(rows)
    @max_y = rows.size - 1
    @max_x = rows.first.size - 1

    @herds = { '>' => Set.new, 'v' => Set.new }
    (0..@max_y).each do |y|
      (0..@max_x).each do |x|
        sc = rows[y][x]
        @herds[sc] << [x,y] if @herds[sc]
      end
    end
    @all = @herds.values.inject(&:+)
  end

  def move!
    moved = 0
    @herds.each do |dir,herd|
      new_all, new_herd = @all.clone, Set.new
      herd.each do |c|
        lookat = dir == '>' ? [c[0]+1,c[1]] : [c[0],c[1]+1]
        lookat[0] = 0 if lookat[0] > @max_x
        lookat[1] = 0 if lookat[1] > @max_y

        if !@all.include?(lookat)
          new_all.delete(c)
          new_all << lookat
          new_herd << lookat
          moved += 1
        else
          new_herd << c
        end
      end
      @herds[dir] = new_herd
      @all = new_all
    end
    moved
  end

  # def inspect
  #   (0..@max_y).map do |y|
  #     (0..@max_x).map do |x|
  #       a = @herds.detect{ |dir,herd| herd.include?([x,y]) }
  #       a ? a.first : '.'
  #     end.join
  #   end.join("\n")
  # end

end


start = Time.now
input = File.readlines("input", chomp: true).map(&:chars)
grid = CucumberGrid.new(input)
puts "Prep: #{Time.now - start}s"


start = Time.now
part1 = 1
part1 += 1 until grid.move! == 0
puts "Part 1: #{part1} (#{Time.now - start}s)"