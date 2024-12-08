require_relative '../util/time'

def prep
  File.readlines("input", chomp: true)
    .map{ |l|
      k,vs = l.split(": ")
      [k.to_i, vs.split.map(&:to_i)]
    }.to_h
end

def step(a, e, i, ops)
  return true if a == 0
  return false if a != a.to_i || a < 0 || i < 0

  t = e[i]
  ops.any? do |op|
    if op == :|
      mag = 10 ** (Math.log10(t).to_i + 1)
      a % mag == t ? step( (a - t) / mag, e, i - 1, ops) : false
    else
      step(a.send(op, t), e, i - 1, ops)
    end
  end
end

def calc(input, more_ops = [])
  ops = [:-, :/] + more_ops
  input.sum{ |a,e| step(a.to_f, e, e.size - 1, ops) ? a : 0 }
end

input = time("Prep", false){ prep }
time("Part 1"){ calc(input) }
time("Part 2"){ calc(input, [:|]) }