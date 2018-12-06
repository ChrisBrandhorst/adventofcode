input = File.readlines("input")

class Program
  attr_accessor :name, :weight, :called
  @all = {}

  class << self
    attr_accessor :all
    def add(line)
      parts = line =~ /^(\w+) \((\d+)\)( -> (.*))?$/
      program = Program.new( $1, $2.to_i, ($4 || "").split(", ") )
      @all[program.name] = program
    end
  end

  def initialize(name, weight, called)
    self.name = name
    self.weight = weight
    self.called = called
  end

  def to_s
    "#{self.name}, #{self.weight}, #{self.called.join(',')}"
  end

  def total_weight
    self.weight + self.called_weight
  end

  def called_weight
    called.inject(0){ |sum,p| sum + p.total_weight }
  end

end

input.each{ |l| Program.add(l) }
Program.all.values.each{ |p| p.called = p.called.map{ |n| Program.all[n] } }

bottom = (Program.all.values - Program.all.values.map(&:called).flatten).first
puts "Part 1: #{bottom.name}"


def compare_weights(program, diff = 0)
  weights = program.called.map(&:total_weight)
  if weights.uniq.size == 1
    program.weight - diff
  else
    min = weights.min
    max = weights.max
    program = program.called.find{ |p| p.total_weight == max }
    compare_weights(program, max - min)
  end
end
puts "Part 2: #{compare_weights(bottom)}"