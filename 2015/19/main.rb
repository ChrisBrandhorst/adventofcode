require 'set'

start = Time.now
input = File.read("input", chomp: true).split("\n\n")
rules = {}
input[0].split("\n").map{ s = _1.split; (rules[s.first] ||= []) << s.last }
medicine = input[1]
puts "Prep: #{Time.now - start}s"


@fabricate_mem = {}
def fabricate(medicine, rules)
  if @fabricate_mem[medicine]
    return @fabricate_mem[medicine]
  end
  created = Set.new
  (0...medicine.size).each do |i|
    rules.each do |f,tos|
      tos.each do |t|
        if medicine[i,f.size] == f
          n = medicine.dup
          n[i,f.size] = t
          created << n
        end
      end
    end
  end
  @fabricate_mem[medicine] = created
  created
end

start = Time.now
part1 = fabricate(medicine, rules).size
puts "Part 1: #{part1} (#{Time.now - start}s)"


class String
  def atomize
    self.split(/(?=[A-Z])/)
  end
end

# Rn Y Ar can be seen as the characters ( , )
start = Time.now
part2 = medicine.scan(/[A-Z]/).size - medicine.scan(/(Rn|Ar)/).size - 2 * medicine.scan(/Y/).size - 1
puts "Part 2: #{part2} (#{Time.now - start}s)"