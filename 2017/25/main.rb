input = File.readlines("input", chomp: true)

start = input.shift[-2]
steps = input.shift.scan(/\d+/).first.to_i
instructions = {}

until input.empty?
  input.shift
  state = input.shift[-2]
  instructions[state] = {}
  2.times do
    cond = input.shift[-2].to_i
    instructions[state][cond] = {
      val:  input.shift[-2].to_i,
      move: input.shift.scan(/left|right/).first.to_sym,
      to:   input.shift[-2]
    }
  end
end

state, slot, tape = start, 0, {}
steps.times do
  instr = instructions[state][ tape[slot] || 0 ]
  tape[slot] = instr[:val]
  slot += instr[:move] == :left ? -1 : 1
  state = instr[:to]
end

puts "Part 1: #{tape.values.sum}"