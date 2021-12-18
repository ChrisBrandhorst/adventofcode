
class Number

  attr_accessor :parent
  attr_reader :val
  attr_reader :left, :right

  def initialize(val, parent = nil)
    @parent = parent
    if val.is_a?(Integer)
      @val = val
    else
      @left = val[0].is_a?(Number) ? val[0] : Number.new(val[0], self)
      @right = val[1].is_a?(Number) ? val[1] : Number.new(val[1], self)
    end
  end

  def is_regular?
    !@val.nil?
  end

  def is_pair?
    !self.is_regular?
  end

  def inspect
    is_regular? ? @val.to_s : "[#{@left.inspect},#{@right.inspect}]"
  end

  def depth
    depth, parent = 0, self
    depth += 1 while parent = parent.parent
    depth
  end

  def magnitude
    if self.is_regular?
      @val
    else
      3 * @left.magnitude + 2 * @right.magnitude
    end
  end

  def leftmost_exploding_pair
    if self.is_regular?
      nil
    else
      ret = @left.leftmost_exploding_pair || @right.leftmost_exploding_pair
      ret = self if !ret && self.depth == 4
      ret
    end
  end

  def lefmost_splitting_regular
    if self.is_regular?
      if @val >= 10
        self
      else
        nil
      end
    else
      @left.lefmost_splitting_regular || @right.lefmost_splitting_regular
    end
  end

  def add(other)
    if self.is_regular? && other.is_regular?
      @val += other.val
    elsif self.is_pair? && other.is_pair?
      self.parent = other.parent = Number.new([self, other])
    end
  end

  def explode!
    left_number = find_neighbour(:left)
    right_number = find_neighbour(:right)

    left_number.add(@left) if left_number
    right_number.add(@right) if right_number

    @left = nil
    @right = nil
    @val = 0
  end

  def find_neighbour(side)
    this = side == :left ? :left : :right
    that = side == :left ? :right : :left

    target = self
    walking_up = true
    
    while true
      if target.nil?
        return nil
      elsif walking_up
        if target.send(this).is_regular? && target != self
          return target.send(this)
        else
          parent = target.parent
          if parent && parent.send(this).is_pair? && parent.send(this) != target
            target = parent.send(this)
            walking_up = false
          else
            target = parent
          end
        end
      else
        if target.send(that).is_regular?
          return target.send(that)
        else
          target = target.send(that)
        end
      end
    end

  end

  def split!
    half = @val.to_f / 2
    @val = nil
    @left = Number.new(half.floor, self)
    @right = Number.new(half.ceil, self)
  end

end


start = Time.now
input = File.readlines("input", chomp: true).map{ |l| eval(l) }
puts "Prep: #{Time.now - start}s"


def build_numbers(input)
  input.map{ |l| Number.new(l) }
end

def reduce(number)
  while true
    to_explode = number.leftmost_exploding_pair
    to_explode.explode! if to_explode

    to_split = !to_explode && number.lefmost_splitting_regular
    to_split.split! if to_split
    break if !to_explode && !to_split

  end
  number
end


start = Time.now
part1 = build_numbers(input).inject(nil){ |sum,pair| sum.nil? ? pair : reduce(sum.add(pair)) }.magnitude
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = (0...input.size).map do |m|
  (0...input.size).map do |n|
    if m == n
      -1
    else
      numbers = build_numbers(input)
      reduce(numbers[m].add(numbers[n])).magnitude
    end
  end.max
end.max

puts "Part 2: #{part2} (#{Time.now - start}s)"