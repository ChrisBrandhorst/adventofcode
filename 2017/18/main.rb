input = File.readlines("input").map do |i|
  m = i =~ /^([a-z]{3})\s([a-z0-9]*)\s?(.*)$/
  {ins: $1.to_sym, reg: $2, val: $3 }
end

class Program
  attr_accessor :id
  attr_accessor :send_count

  def initialize(steps, id = 0, queues = nil)
    @steps = steps
    @registers = {'p' => id}
    @pos = 0
    @id = id
    if queues.is_a?(Hash)
      @registers['p'] = id
      @queues = queues
      @send_count = 0
    else
      @last_freq_val = 0
    end
  end

  def first_part?
    @queues.nil?
  end

  def step_until_rcv!
    loop do
      ret = self.step!
      unless ret.nil?
        puts "No more steps for program #{@id}"
        return ret
      end
    end
  end

  def next_step
    @steps[@pos]
  end

  def has_next_step?
    return !self.next_step.nil?
  end

  def wait_for_queue?
    self.first_part? ? false : self.has_next_step? && self.next_step[:ins] == :rcv && @queues[@id].empty?
  end

  def can_proceed?
    has_next_step? && !wait_for_queue?
  end

  def step!
    return false unless self.can_proceed?
    step = self.next_step

    case step[:ins]
    when :snd
      if self.first_part?
        @last_freq_val = self.reg_val(step[:reg])
      else
        @queues[1 - @id] << self.reg_val(step[:reg])
        @send_count += 1
      end
    when :set
      @registers[step[:reg]] = self.reg_val(step[:val])
    when :add
      @registers[step[:reg]] = self.reg_val(step[:reg]) + self.reg_val(step[:val])
    when :mul
      @registers[step[:reg]] = self.reg_val(step[:reg]) * self.reg_val(step[:val])
    when :mod
      @registers[step[:reg]] = self.reg_val(step[:reg]) % self.reg_val(step[:val])
    when :rcv
      if self.first_part?
        if self.reg_val(step[:reg]) > 0
          return @last_freq_val
        end
      else
        @registers[step[:reg]] = @queues[@id].shift
      end
    when :jgz
      if self.reg_val(step[:reg]) > 0
        @pos += self.reg_val(step[:val])
        return
      end
    end

    @pos += 1
    nil
  end

  def reg_val(v)
    v.to_i.to_s == v ? v.to_i : (@registers[v] || 0)
  end

end

program = Program.new(input)
puts "Part 1: #{program.step_until_rcv!}"

queues = {0 => [], 1 => []}
program0 = Program.new(input, 0, queues)
program1 = Program.new(input, 1, queues)

while program0.can_proceed? || program1.can_proceed?
  program0.step!
  program1.step!
end
puts "Part 2: #{program1.send_count}"