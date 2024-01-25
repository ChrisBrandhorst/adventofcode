require 'prime'

input = File.readlines("input").map do |i|
  m = i =~ /^([a-z]{3})\s([a-z0-9]*)\s?(.*)$/
  {ins: $1.to_sym, reg: $2, val: $3 }
end

class Program
  attr_accessor :id
  attr_accessor :mul_count

  def initialize(steps)
    @steps = steps
    self.reset!
  end

  def reset!
    @pos = 0
    @registers = {}
    @mul_count = 0
    self
  end

  def run!
    while self.step!.nil?; end
    self
  end

  def [](reg)
    @registers[reg]
  end

  def []=(reg, val)
    @registers[reg] = val
  end

  def step!
    step = @steps[@pos]
    return false if step.nil?

    case step[:ins]
    when :set
      @registers[step[:reg]] = self.reg_val(step[:val])
    when :sub
      @registers[step[:reg]] = self.reg_val(step[:reg]) - self.reg_val(step[:val])
    when :mul
      @registers[step[:reg]] = self.reg_val(step[:reg]) * self.reg_val(step[:val])
      @mul_count += 1
    when :jnz
      if self.reg_val(step[:reg]) != 0
        @pos += self.reg_val(step[:val]) - 1
      end
    end

    @pos += 1
    nil
  end

  def reg_val(v)
    v.to_i.to_s == v ? v.to_i : (@registers[v] || 0)
  end

end

program = Program.new(input).run!
puts "Part 1: #{program.mul_count}"


# Reverse engineered the assembly to:
# 
#   b = 57
#   c = b
#   if a != 0
#     b = b * 100
#     b = b - -100000
#     c = b
#     c = c - -17000
#   end
#   loop
#     f = 1
#     d = 2
#     loop
#       e = 2
#       loop
#         g = d
#         g = g * e
#         g = g - b
#         f = 0 if g == 0
#         e = e - -1
#         g = e
#         g = g - b
#         break if g == 0
#       end
#       d = d - -1
#       g = d
#       g = g - b
#       break if g == 0
#     end
#     h = h - -1 if f == 0
#     g = b
#     g = g - c
#     break if g == 0
#     b = b - -17
#   end
#
# Then reduce to:
b = 57 * 100 + 100000
#   c = b + 17000
#   h = 0
#   loop do
#     h += 1 if !b.prime?
#     break if b == c
#     b += 17
#   end
# 
# Which is the number of non-primes of each 17th number between b and c
part2 = (0..1000).count{ !(b + _1 * 17).prime? }
puts "Part 2: #{part2}"