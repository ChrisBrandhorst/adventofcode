require_relative '../util/time'

def prep
  File.read("input", chomp: true).split("\n\n")
    .map{ _1.scan(/\d+/).map(&:to_i) }
end

def combo(operand, regs)
  operand <= 3 ? operand : regs[operand - 4]
end

def part1(regs, nos)
  pointer, out = 0, []

  while nos[pointer]
    opcode = nos[pointer]
    operand = nos[pointer + 1]

    jumped = false
    case opcode
    when 0
      regs[0] = regs[0] / 2**combo(operand, regs)
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
      regs[1] = regs[0] / 2**combo(operand, regs)
    when 7
      regs[2] = regs[0] / 2**combo(operand, regs)
    end

    pointer += 2 unless jumped
  end

  out
end

def part2(nos)
  low = Float::INFINITY
  q = [[0, nos.length - 1]]
  nos_part = nos[0...-2]

  until q.empty?
    a, i = q.pop
    (a..a+7).each do |a|
      if part1([a,0,0], nos_part)[0] == nos[i]
        if i == 0
          low = a if a < low
        else
          q << [a * 8, i - 1]
        end
      end
    end
  end

  low
end

regs, nos = time("Prep", false){ prep }
time("Part 1"){ part1(regs.clone, nos).join(",") }
a = time("Part 2"){ part2(nos) }
time("Part 2 check"){ r = part1([a,0,0], nos); "#{r.join(",")} / #{r == nos}" }