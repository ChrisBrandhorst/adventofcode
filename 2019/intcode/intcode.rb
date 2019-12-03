class Intcode

  def initialize(mem)
    @mem = mem.clone
  end

  def []=(addr, val)
    @mem[addr] = val
  end

  def [](addr)
    @mem[addr]
  end

  def run(noun, verb)
    ptr = 0
    wm = @mem.clone
    wm[1] = noun
    wm[2] = verb
    loop do
      case wm[ptr]
      when 1
        wm[wm[ptr+3]] = wm[wm[ptr+1]] + wm[wm[ptr+2]]
        ptr += 4
      when 2
        wm[wm[ptr+3]] = wm[wm[ptr+1]] * wm[wm[ptr+2]]
        ptr += 4
      when 99
        break
      end
    end
    wm[0]
  end

end