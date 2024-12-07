require_relative '../util/time'

def prep
  File.readlines("input", chomp: true)
    .map{ |l|
      k,vs = l.split(": ")
      [k.to_i, vs.split.map(&:to_i)]
    }.to_h
end

class Integer
  def |(b)
    l = Math.log10(b).to_i + 1
    self * 10**l + b
  end
end

def calc(input, ops = [])
  ops = [:+, :*] + ops
  input.sum{ |a,e| step(e[0], e, 1, ops, a) ? a : 0 }
end

def step(r, e, i, ops, a)
  return true if r == a
  return false if i == e.size
  ops.any?{ |op| step( r.send(op, e[i]), e, i + 1, ops, a ) }
end

input = time("Prep", false){ prep }
time("Part 1"){ calc(input) }
time("Part 2"){ calc(input, [:|]) }