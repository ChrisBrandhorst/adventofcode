start = Time.now
input = File.readlines("input", chomp: true).map{ |l| l.delete(' ') }
puts "Prep:   #{Time.now - start}s"

def calc1(l)
  l = l.clone
  while l.index(/[+*]/) do
    l.sub!( /(^|\()([\d+*]+)($|\))/ ) do
      parts = $2.scan(/(\d+|\*|\+)/).flatten
      parts.each_slice(2).inject(parts.shift.to_i){ |r,(op,n)| op == '+' ? r + n.to_i : r * n.to_i }
    end
  end
  l.to_i
end

def calc2(l)
  l = l.clone
  while l.index(/[*+]/) do
    l.sub!( /(\d+)(\+(\d+))+/ ){ |s| eval(s) }
    l.sub!( /(^|\()([\d\*]+)($|\))/ ){ eval($2) }
  end
  l.to_i
end

start1 = Time.now
part1 = input.sum{ |i| calc1(i) }
puts "Part 1: #{part1} (#{Time.now - start1}s)"

start2 = Time.now
part2 = input.sum{ |i| calc2(i) }
puts "Part 2: #{part2} (#{Time.now - start2}s)"

puts "Total:  #{Time.now - start}s"


# First solution: left-to-right recursive processing
# 
# def calc1(l)
#   r, op = nil

#   loop do
#     f = l.shift
#     break if f.nil?

#     case f
#     when /[*|+]/
#       op = f
#     when '(', /\d/
#       v = f == '(' ? calc1(l) : f.to_i
#       if r.nil?;        r = v
#       elsif op == '*';  r *= v
#       elsif op == '+';  r += v
#       end
#     when ')'
#       break
#     end

#   end
#   r
# end