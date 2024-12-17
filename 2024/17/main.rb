require_relative '../util/time'

def prep
  File.read("input", chomp: true).split("\n\n")
    .map{ _1.scan(/\d+/).map(&:to_i) }
end

def combo(operand, regs)
  if operand <= 3
    operand
  else
    regs[operand - 4]
  end
end

def part1(regs, nos)
  regs = regs.clone
  pointer = 0
  out = []

  while nos[pointer]
    opcode = nos[pointer]
    operand = nos[pointer + 1]

    jumped = false
    case opcode
    when 0
      regs[0] = regs[0] / ( 2 ** combo(operand, regs) )
    when 1
      regs[1] = regs[1] ^ operand
    when 2
      regs[1] = combo(operand, regs) % 8
    when 3
      if regs[0] != 0
        pointer = operand
        jumped = true
      end
    when 4
      regs[1] = regs[1] ^ regs[2]
    when 5
      out << combo(operand, regs) % 8
    when 6
      regs[1] = regs[0] / ( 2 ** combo(operand, regs) )
    when 7
      regs[2] = regs[0] / ( 2 ** combo(operand, regs) )
    end

    pointer += 2 unless jumped
  end

  out.join(",")
end

def part1_coded(regs, nos)
  out = []
  loop do
    regs[1] = (regs[0] % 8) ^ 2
    out << ((regs[0] / 2**regs[1]) ^ regs[1] ^ 7) % 8
    regs[0] = regs[0] / 8
    break if regs[0] == 0
  end
  out.join(",")
end

def part2(regs, nos)
  a = 0
  nos.reverse_each do |t|
    8.times do
      b = (a % 8) ^ 2
      b = ((a / 2**b) ^ b ^ 7) % 8
      break a *= 8 if b == t
      a += 1
    end
  end
  a / 8
end

regs, nos = time("Prep", false){ prep }
time("Part 1v0"){ part1(regs, nos) }
time("Part 1v1"){ part1_coded(regs, nos) }
time("Part 2"){ part2(regs, nos) }