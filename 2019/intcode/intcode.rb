class Intcode

  attr_reader :output

  def initialize(mem)
    @mem = mem.clone
    @loop_mode = false
    @verbose = false
    reset!
  end

  def reset!
    @wm = @mem.clone
    @ptr = 0
    @rel_base = 0
    @output = nil
    @input = []
    self
  end

  def verbose!(verbose = true)
    @verbose = verbose
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
    @wm[ptr] || 0
  end

  def []=(ptr, val)
    @wm[ptr] = val
  end

  def run
    self[1] = @noun unless @noun.nil?
    self[2] = @verb unless @verb.nil?

    0.step do |i|
      opcode, p1, p2, out = get_cur_instr

      case opcode
      when 1
        self[out] = p1 + p2
        @ptr += 4
      when 2
        self[out] = p1 * p2
        @ptr += 4
      when 3
        if block_given?
          inp = yield(:in)
        else
          inp = get_inp
        end
        self[out] = inp
        puts "Input: #{inp}" if @verbose
        break if inp.nil?
        @ptr += 2
      when 4
        @output = p1
        @ptr += 2
        puts "Output: #{@output}" if @verbose
        yield(:out, @output) if block_given?
        break if @loop_mode
      when 5
        @ptr = p1 != 0 ? p2 : @ptr + 3
      when 6
        @ptr = p1 == 0 ? p2 : @ptr + 3
      when 7
        self[out] = p1 < p2 ? 1 : 0
        @ptr += 4
      when 8
        self[out] = p1 == p2 ? 1 : 0
        @ptr += 4
      when 9
        @rel_base += p1
        @ptr += 2
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
    opcode = self[@ptr] > 9 ? self[@ptr] % 100 : self[@ptr]
    modes = self[@ptr] / 100

    [
      opcode,
      get_in_param(modes, 1),
      get_in_param(modes, 2),
      get_out_param(modes, opcode == 3 ? 1 : 3)
    ]
  end

  def get_in_param(modes, n)
    val = self[@ptr+n]
    mode = get_mode(modes, n)
    if val.nil? || mode == 1
      val
    elsif mode == 2
      self[val + @rel_base]
    else
      self[val]
    end
  end

  def get_out_param(modes, n)
    val = self[@ptr+n]
    mode = get_mode(modes, n)
    val.nil? || mode == 0 ? val : val + @rel_base
  end

  def get_mode(modes, n)
    case n
    when 1
      modes % 10
    when 2
      modes / 10 % 10
    when 3
      modes / 100
    end
  end

end