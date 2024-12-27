require_relative '../util/time'
require 'set'

class Gate

  attr_reader :in1, :in2, :op
  attr_accessor :out
  attr_reader :z_no

  def initialize(in1, op, in2, out)
    @in1, @in2, @out, @op = in1, in2, out, op
    @z_no = out[1..-1] if out[0] == "z"
  end

  def has_in?(k)
    @in1 == k || @in2 == k
  end

  def wires
    [@in1, @in2, @out]
  end

  def calc(in1, in2)
    case @op
    when "AND"; in1 & in2
    when "OR";  in1 | in2
    when "XOR"; in1 ^ in2
    end
  end

  def inspect
    "#{in1} #{op} #{in2} -> #{out}"
  end

end

def prep(file = "input")
  wires, gates = File.read(file, chomp: true).split("\n\n")
    .map{ |b| b.split("\n").map{ _1.scan(/([a-z\d]{3}|\d+|AND|OR|XOR)/) } }
  [
    wires.map{ [_1[0][0], _1[1][0].to_i] }.to_h,
    gates.map{ Gate.new(*_1.map(&:first)) }
  ]
end

def calc(wires, gates)
  wires, gates = wires.dup, gates.dup

  until (g = gates.shift).nil?
    next gates << g if wires[g.in1].nil? || wires[g.in2].nil?
    wires[g.out] = g.calc(wires[g.in1], wires[g.in2])
  end

  get_value(wires, "z")
end

def get_value(wires, n)
  wires.select{ _1[0] == n }.sort.map(&:last).reverse.join.to_i(2)
end

def swap(a, b)
  a.out, b.out = b.out, a.out
end

def fix_block(i, gates)
  no = i.to_s.rjust(2, "0")

  # The two x/y-input blocks can always be found by looking at a single x-input
  and1, xor1 = gates.select{ _1.has_in?("x#{no}") }.sort{ _1.op <=> _2.op }
  # We have fixed the z-out blocks, so XOR2 and AND2 can also be found
  xor2 = gates.detect{ _1.out == "z#{no}" }
  and2 = gates.detect{ _1.has_in?(xor2.in1) && _1.has_in?(xor2.in2) && _1.op == "AND" }

  # Find the OR gate for this block
  io_wires = [and1, xor1, xor2, and2].map(&:wires).flatten.uniq
  or1 = gates.detect{ ([_1.in1, _1.in2, _1.out] & io_wires).size == 2 && _1.op == "OR" }
  
  # These are then the gates which may have a wrong output
  choices = [xor1, and1, and2, or1]

  # Check the inputs of specific gates against what we know should be present.
  # If a check is wrong, we can find the gate with the wrong output.
  wrong_outs = Set.new

  # XOR2 should have XOR1 as input
  wrong_outs << choices.detect{ xor2.has_in?(_1.out) } if !xor2.has_in?(xor1.out)
  # OR1 should have AND1 as input
  wrong_outs << choices.detect{ or1.has_in?(_1.out) } if !or1.has_in?(and1.out)
  # AND2 should have XOR1 as input
  wrong_outs << choices.detect{ and2.has_in?(_1.out) } if !and2.has_in?(xor1.out)
  # OR1 should have AND2 as input
  wrong_outs << choices.detect{ or1.has_in?(_1.out) } if !or1.has_in?(and2.out)

  swap(*wrong_outs)
end

def fix_z_out(wrong, gates)
  # The two x/y-input blocks can always be found by looking at a single x-input
  and1, xor1 = gates.select{ _1.has_in?("x#{wrong.z_no}") }.sort{ _1.op <=> _2.op }

  # Find the other XOR gate for this block, that gate should have a z-out
  io_wires = [wrong.in1, wrong.in2, and1.out, xor1.out]
  real_out = gates.detect{ _1.op == "XOR" && _1 != xor1 && (_1.wires & io_wires).any? }

  # Swap
  swap(real_out, wrong)
end

# See adder_block.png to check which gates are named how
def part2(wires, gates)
  outs = []

  # First fix Z-output gates which are not XOR (except the most significant one)
  gates.select{ !_1.z_no.nil? && _1.op != "XOR" && _1.z_no.to_i != wires.size / 2 }.each do |g|
    outs += fix_z_out(g, gates)
  end

  # Then fix the other swapped wires
  correct = get_value(wires, "x") + get_value(wires, "y")
  loop do
    # Check the index of the least significant difference with the correct answer
    i = (calc(wires, gates) ^ correct).to_s(2).reverse.index("1")
    break if i.nil?
    outs += fix_block(i, gates)
  end

  outs.sort.join(",")
end

wires, gates = time("Prep", false){ prep("input") }
time("Part 1"){ calc(wires, gates) }
time("Part 2"){ part2(wires, gates) }