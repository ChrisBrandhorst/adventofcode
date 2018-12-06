input = File.readlines("input").map{ |i| i.split(": ").map(&:to_i) }.inject([]){ |res,i| res[i[0]] = i[1]; res }
# input = [3,2,nil,nil,4,nil,4]

# def print_state(scanner, input)
#   scanner.each_with_index do |v,depth|
#     print " #{depth}  "
#   end
#   print "\n"

#   (0..input.compact.max-1).each do |range|
#     (0..input.size - 1).each do |depth|
#       if input[depth] && range >= input[depth] || input[depth].nil? && range > 0
#         print "    "
#       elsif input[depth].nil?
#         print "... "
#       else
#         print "[#{scanner[depth] == range ? 'S' : ' '}] "
#       end
#     end
#     print "\n"
#   end
# end

def scanner_is_zero(tick, range)
  tick % ((range - 1) * 2) == 0
end

def get_catches(input, delay = 0)
  catches = []

  (delay..input.size-1+delay).each do |tick|
    depth = tick - delay
    catches << depth if depth >= 0 && !input[depth].nil? && scanner_is_zero(tick, input[depth])
  end

  catches
end

def caught?(input, delay = 0)
  (delay..input.size-1+delay).any? do |tick|
    depth = tick - delay
    depth >= 0 && !input[depth].nil? && scanner_is_zero(tick, input[depth])
  end
end

def calculate_severity(input, delay = 0)
  get_catches(input, delay).map{ |i| i * input[i] }.sum
end

puts "Part 1: #{calculate_severity(input)}"

delay = 0
delay += 1 while caught?(input, delay)
puts "Part 2: #{delay}"