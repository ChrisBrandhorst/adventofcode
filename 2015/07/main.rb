start = Time.now
input = File.readlines("input", chomp: true)
  .map{ _1.scan(/(([a-z\d]+)\s)?((AND|OR|NOT|LSHIFT|RSHIFT)\s)?([a-z\d]+) -> ([a-z]+)/).first }
puts "Prep: #{Time.now - start}s"


def get(v, wires)
  if v.nil?
    nil
  elsif v == "0"
    0
  elsif v.to_i == 0
    wires[v]
  else
    v.to_i
  end
end


def run(instructions)
  wires = {}
  while instructions.any?

    i = instructions.shift

    v1 = get(i[1], wires)
    op = i[3]
    v2 = get(i[4], wires)
    target = i[5]

    if !v2 || (!v1 && !(op.nil? || op == "NOT"))
      instructions << i
      next
    end

    case op
    when nil
      wires[target] = v2
    when "NOT"
      wires[target] = v2 ^ ((1 << 16) - 1)
    when "AND"
      wires[target] = v1 & v2
    when "OR"
      wires[target] = v1 | v2
    when "LSHIFT"
      wires[target] = v1 << v2
    when "RSHIFT"
      wires[target] = v1 >> v2
    end

  end
  wires
end


start = Time.now
part1 = run(input.clone)["a"]
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
input.detect{ _1[5] == "b" }[4] = part1
part2 = run(input.clone)["a"]
puts "Part 2: #{part2} (#{Time.now - start}s)"