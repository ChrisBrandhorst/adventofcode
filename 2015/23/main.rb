start = Time.now
input = File.readlines("input", chomp: true)
  .map{
    r = _1.scan(/(\w+) (\w)?,? ?([+-]\d+)?/).first
    r[1] = r[1].to_sym if r[1]
    r[2] = r[2].to_i if r[2]
    r
  }
puts "Prep: #{Time.now - start}s"


def run(instructions, reg_a = 0)
  regs = { a: reg_a, b: 0 }

  i = 0
  while inst = instructions[i]
    op, reg, off = inst
    case op
    when "hlf"; regs[reg] /= 2
    when "tpl"; regs[reg] *= 3
    when "inc"; regs[reg] += 1
    when "jmp"; i += off - 1
    when "jie"; i += off - 1 if regs[reg] % 2 == 0
    when "jio"; i += off - 1 if regs[reg] == 1
    end
    i += 1
  end

  regs
end


start = Time.now
part1 = run(input)[:b]
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = run(input, 1)[:b]
puts "Part 2: #{part2} (#{Time.now - start}s)"