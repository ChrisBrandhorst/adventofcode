start = Time.now
input = File.readlines("input", chomp: true)
  .map{ |l| l.split.map{ |c| c.match(/[-\d]+/) ? c.to_i : c } }
puts "Prep: #{Time.now - start}s"


def run_bf(program, input)
  digits = input.clone
  mem = {'w'=>0,'x'=>0,'y'=>0,'z'=>0}
  program.each do |op,a,b|
    b = mem[b] unless b.is_a?(Integer)
    case op
    when 'inp'
      raise "Input is empty!" if digits.empty?
      mem[a] = digits.shift
    when 'add'
      mem[a] = mem[a] + b
    when 'mul'
      mem[a] = mem[a] * b
    when 'div'
      mem[a] = mem[a] / b
    when 'mod'
      mem[a] = mem[a] % b
    when 'eql'
      mem[a] = mem[a] == b ? 1 : 0
    end
  end

  mem['z']
end


consts = (0...14).map do |pl|
  [
    input[pl*18 + 5][2],
    input[pl*18 + 15][2]
  ]
end
# [12, 4]
# [11, 11]
# [13, 5]
# [11, 11]
# [14, 14]
# [-10, 7]
# [11, 11]
# [-9, 4]
# [-3, 6]
# [13, 5]
# [-5, 9]
# [-10, 12]
# [-4, 14]
# [-5, 14]

def run_part(consts, w, z, i)
  puts "#{'%02d' % i}, w: #{w}, consts: #{consts}, z: #{z}"
  if z % 26 + consts[0] - w == 0
    z /= 26 
    puts "  z --> #{z}"
  else
    z = z * 26 + w + consts[1]
    puts "  z --> #{z}"
  end
  puts ""
  z
end

def run(consts, mn)
  z = 0
  mn.each_with_index do |w,i|
    z = run_part(consts[i], w, z, i)
  end
  z
end


# puts consts.map{|c|c.inspect}.join("\n")

# cur = ('9' * 14).to_i
cur = 92915979999498


while true
  digits = cur.digits
  if !(zi = digits.index(0)).nil?
    cur -= 10**zi
  else
    z = 0
    digits.reverse.each_with_index do |w,i|
      z = run_part(consts[i], w, z, i)
    end
    break if z == 0
    cur -= 1
  end
end




start = Time.now



part1 = nil
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = nil
puts "Part 2: #{part2} (#{Time.now - start}s)"