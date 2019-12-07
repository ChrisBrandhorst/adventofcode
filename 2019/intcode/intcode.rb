class Intcode

  attr_reader :output

  def initialize(mem)
    @mem = mem.clone
    @loop_mode = false
    reset!
  end

  def reset!
    @wm = @mem.clone
    @ptr = 0
    @output = nil
    @input = []
    self
  end

  def loop_mode(lm = true)
    @loop_mode = lm
    self
  end

  def with_input(inp)
    if inp.is_a?(Array)
      @input = @input + inp
    else
      @input << inp
    end
    self
  end

  def with_nv(noun, verb)
    @noun = noun
    @verb = verb
    self
  end

  def [](ptr)
    @wm[ptr]
  end

  def run
    @wm[1] = @noun unless @noun.nil?
    @wm[2] = @verb unless @verb.nil?

    0.step do |i|
      opcode, p1, p2, out = get_cur_instr
      
      case opcode
      when 1
        @wm[out] = p1 + p2
        @ptr += 4
      when 2
        @wm[out] = p1 * p2
        @ptr += 4
      when 3
        inp = get_inp
        @wm[out] = inp
        @ptr += 2
      when 4
        @output = p1
        @ptr += 2
        break if @loop_mode
      when 5
        @ptr = p1 != 0 ? p2 : @ptr + 3
      when 6
        @ptr = p1 == 0 ? p2 : @ptr + 3
      when 7
        @wm[out] = p1 < p2 ? 1 : 0
        @ptr += 4
      when 8
        @wm[out] = p1 == p2 ? 1 : 0
        @ptr += 4
      when 99
        @output = @input.first if @loop_mode && i == 0
        break
      end
    end
    @input.clear
    self
  end

  def get_inp
    @input.size == 1 ? @input.first : @input.shift
  end

  def get_cur_instr
    opcode = @wm[@ptr] > 9 ? @wm[@ptr] % 100 : @wm[@ptr]
    modes = @wm[@ptr] / 100
    [
      opcode,
      get_cur_param(modes, 1),
      get_cur_param(modes, 2),
      opcode == 3 ? @wm[@ptr+1] : @wm[@ptr+3]
    ]
  end

  def get_cur_param(modes, n)
    val = @wm[@ptr+n]
    mode = n == 1 ? modes % 10 : modes / 10
    val.nil? || mode == 1 ? val : @wm[val]
  end

end