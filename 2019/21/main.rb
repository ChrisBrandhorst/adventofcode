require '../intcode/intcode'

input = File.read("input").split(",").map(&:to_i)

def jumpdroid(input, in_buffer)
  intcode = Intcode.new(input)

  out_buffer = []
  in_buffer = in_buffer.join("\n").split("")

  intcode.run do |op,out|
    if op == :out
      if out > 255
        return out
      else
        out_buffer << out.chr
      end
    else
      puts out_buffer.join("") if out_buffer.any?
      out_buffer = []
      in_buffer.shift.ord
    end
  end

  puts out_buffer.join("") if out_buffer.any?

end

start = Time.now
part1 = jumpdroid(input, [
  "NOT C J",
  "AND D J",
  "NOT A T",
  "OR T J",
  "WALK\n"
])
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = jumpdroid(input, [
  "NOT B J",
  "AND D J",
  "NOT A T",
  "OR T J",
  "NOT C T",
  "AND D T",
  "AND H T",
  "OR T J",
  "RUN\n"
])
puts "Part 2: #{part2} (#{Time.now - start}s)"