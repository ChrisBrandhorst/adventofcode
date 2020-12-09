INSTR_FORMAT = /^(\w{3}) ([-+]\d+)$/

def run(input, nil_if_stuck, toggle_i = nil)
  ops, pos, acc = input.clone, 0, 0

  while i = ops[pos]
    ops[pos] = nil
    toggle_op = i == toggle_i ? "nop" : "jmp"
    pos += i.first == toggle_op ? i.last : 1
    acc += i.last if i.first == "acc"
  end

  pos < ops.size && nil_if_stuck ? nil : acc
end

start = Time.now
input = File.readlines("input")
  .map{ |i| i.match(INSTR_FORMAT).captures }
  .each{ |i| i[1] = i[1].to_i }
puts "Prep: #{Time.now - start}s"

start = Time.now
part1 = run(input, false)
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = 0
input.each do |i|
  part2 = run(input, true, i)
  break unless part2.nil?
end
puts "Part 2: #{part2} (#{Time.now - start}s)"