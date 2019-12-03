OP_KEYS = %w{addr addi mulr muli banr bani borr bori setr seti gtir gtri gtrr eqir eqri eqrr}

class Op

  attr_reader :opkey

  def initialize(op)
    @opkey, @ina, @inb, @out = op
  end

  def run!(register)
    send("#{@opkey}!",register)
  end

  def addr(register); register[@ina] + register[@inb]; end
  def addi(register); register[@ina] + @inb; end
  def mulr(register); register[@ina] * register[@inb]; end
  def muli(register); register[@ina] * @inb; end
  def banr(register); register[@ina] & register[@inb]; end
  def bani(register); register[@ina] & @inb; end
  def borr(register); register[@ina] | register[@inb]; end
  def bori(register); register[@ina] | @inb; end
  def setr(register); register[@ina]; end
  def seti(register); @ina; end
  def gtir(register); @ina > register[@inb] ? 1 : 0; end
  def gtri(register); register[@ina] > @inb ? 1 : 0; end
  def gtrr(register); register[@ina] > register[@inb] ? 1 : 0; end
  def eqir(register); @ina == register[@inb] ? 1 : 0; end
  def eqri(register); register[@ina] == @inb ? 1 : 0; end
  def eqrr(register); register[@ina] == register[@inb] ? 1 : 0; end

  OP_KEYS.each do |opkey|
    define_method("is_#{opkey}?") do |register|
      register[@out] == send("#{opkey}", register)
    end
    define_method("#{opkey}!") do |register|
      register[@out] = send("#{opkey}", register)
    end
  end

end

lines = File.readlines("input")
ip_reg = lines.shift.match(/#ip (\d+)/).captures.first.to_i

data = lines.map{ |l| l.match(/([a-z]+) (\d+) (\d+) (\d+)/){ |m|
  Op.new(m.captures.each_with_index.map{ |v,i| i == 0 ? v : v.to_i }) }
}

def run(data, register, ip_reg, ip)
  0.step do |i|
    p ip
    p register
    register[ip_reg] = ip
    op = data[ip]
    op.run!(register)
    ip = register[ip_reg] + 1
    break if data[ip].nil?
  end

  register[0]
end

p run(data, [0] + [0] * 5, ip_reg, 0)