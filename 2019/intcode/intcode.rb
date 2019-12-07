class Intcode

  attr_reader :last_output

  def initialize(mem)
    @mem = mem.clone
    reset!
  end

  def reset!
    @wm = @mem.clone
    @ptr = 0
    @last_output = nil
    @input = []
    self
  end

  def [](ptr)
    @wm[ptr]
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

  def run
    @wm[1] = @noun unless @noun.nil?
    @wm[2] = @verb unless @verb.nil?

    loop do
      opcode, p1, p2, out = get_cur_instr

      case opcode
      when 1
        @wm[out] = p1 + p2
        @ptr += 4
      when 2
        @wm[out] = p1 * p2
        @ptr += 4
      when 3
        # puts "Input: #{@input}"
        @wm[out] = get_inp
        @ptr += 2
      when 4
        # puts "Output: #{p1}"
        @last_output = p1
        @ptr += 2
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
        break
      end
    end
    self
  end

  def get_inp
    # @input.shift
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