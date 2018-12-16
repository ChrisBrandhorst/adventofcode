INPUT1_PATTERN = /(Before: \[|After: |\[)?(\d+)[\s,]+(\d+)[\s,]+(\d+)[\s,]+(\d+)\]?/
OP_KEYS = %w{addr addi mulr muli banr bani borr bori setr seti gtir gtri gtrr eqir eqri eqrr}

class Op

  attr_reader :opcode

  def initialize(before, op, after)
    @before = before
    @opcode, @ina, @inb, @out = op
    @after = after
  end

  def addr; @before[@ina] + @before[@inb]; end
  def addi; @before[@ina] + @inb; end
  def mulr; @before[@ina] * @before[@inb]; end
  def muli; @before[@ina] * @inb; end
  def banr; @before[@ina] & @before[@inb]; end
  def bani; @before[@ina] & @inb; end
  def borr; @before[@ina] | @before[@inb]; end
  def bori; @before[@ina] | @inb; end
  def setr; @before[@ina]; end
  def seti; @ina; end
  def gtir; @ina > @before[@inb] ? 1 : 0; end
  def gtri; @before[@ina] > @inb ? 1 : 0; end
  def gtrr; @before[@ina] > @before[@inb] ? 1 : 0; end
  def eqir; @ina == @before[@inb] ? 1 : 0; end
  def eqri; @before[@ina] == @inb ? 1 : 0; end
  def eqrr; @before[@ina] == @before[@inb] ? 1 : 0; end

  OP_KEYS.each do |opkey|
    define_method("is_#{opkey}?") do
      @after[@out] == method(opkey).call
    end
    define_method("#{opkey}!") do
      @after[@out] = method(opkey).call
    end
  end

  def possible_ops(known = {})
    opkey = known[@opcode]
    if opkey.nil?
      possibles = OP_KEYS.select{ |k| method("is_#{k}?").call } - known.values
      possibles
    else
      [opkey]
    end
  end

end

ops = File.readlines("input_part1")
  .map{ |l| l.match(INPUT1_PATTERN){ |m| m.captures[1..4].map(&:to_i) } }
  .compact
  .each_slice(3)
  .map{ |s| Op.new(*s) }

part1 = ops.select{ |o| o.possible_ops.size >= 3 }.size
puts "Part 1: #{part1}"

opcodes = {}
ops.each do |o|
  possibles = o.possible_ops(opcodes)
  opcodes[o.opcode] = possibles.first if possibles.size == 1
  break if opcodes.keys.size == OP_KEYS.size
end

regs = [0] * 4
data = File.readlines("input_part2")
  .map{ |l| Op.new(regs, l.split(' ').map(&:to_i), regs) }
  .each{ |o| o.method("#{opcodes[o.opcode]}!").call }
puts "Part 2: #{regs.first}"