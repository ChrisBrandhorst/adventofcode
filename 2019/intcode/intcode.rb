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

  def with_input(inp)
    @input = inp
    self
  end

  def with_nv(noun, verb)
    @noun = noun
    @verb = verb
    self
  end

  def run
    ptr = 0
    wm = @mem.clone

    wm[1] = @noun unless @noun.nil?
    wm[2] = @verb unless @verb.nil?

    last_output = nil

    loop do
      opcode, p1, p2, out = get_instruction(wm, ptr)

      case opcode
      when 1
        wm[out] = p1 + p2
        ptr += 4
      when 2
        wm[out] = p1 * p2
        ptr += 4
      when 3
        puts "Input: #{@input}"
        wm[out] = @input
        ptr += 2
      when 4
        puts "Output: #{p1}"
        last_output = p1
        ptr += 2
      when 5
        ptr = p1 != 0 ? p2 : ptr + 3
      when 6
        ptr = p1 == 0 ? p2 : ptr + 3
      when 7
        wm[out] = p1 < p2 ? 1 : 0
        ptr += 4
      when 8
        wm[out] = p1 == p2 ? 1 : 0
        ptr += 4
      when 99
        break
      end
    end
    last_output || wm[0]
  end

  def get_instruction(wm, ptr)
    opcode = wm[ptr] > 9 ? wm[ptr] % 100 : wm[ptr]
    modes = wm[ptr] / 100
    [
      opcode,
      get_param(wm, ptr, modes, 1),
      get_param(wm, ptr, modes, 2),
      opcode == 3 ? wm[ptr+1] : wm[ptr+3]
    ]
  end

  def get_param(wm, ptr, modes, n)
    val = wm[ptr+n]
    mode = n == 1 ? modes % 10 : modes / 10
    val.nil? || mode == 1 ? val : wm[val]
  end

end