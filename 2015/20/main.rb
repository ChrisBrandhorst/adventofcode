start = Time.now
input = File.read("input", chomp: true).to_i
puts "Prep: #{Time.now - start}s"


start = Time.now
presents_1 = {}
presents_2 = {}
(1..input/10).each do |i|
  visits = 0
  (i..input/10).step(i) do |j|
    presents_1[j] ||= 0
    presents_1[j] += i * 10
    if (visits += 1) < 50
      presents_2[j] ||= 0
      presents_2[j] += i * 11
    end
  end
end
part1 = presents_1.filter_map{ _1 if _2 >= input }.min
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
part2 = presents_2.filter_map{ _1 if _2 >= input }.min
puts "Part 2: #{part2} (#{Time.now - start}s)"


# require 'prime'


# class Integer
#   def divisors
#     (1..Math.sqrt(self)).each_with_object([]) { |i, arr| (self % i).zero? && arr << i && self/i != i && arr << self/i }
#   end
# end

# def factors_of(number)
#   primes, powers = number.prime_division.transpose
#   exponents = powers.map{|i| (0..i).to_a}
#   divisors = exponents.shift.product(*exponents).map do |powers|
#     primes.zip(powers).map{|prime, power| prime ** power}.inject(:*)
#   end
#   divisors
# end


# i = 3
# loop do
#   break if factors_of(i).sum * 10 > input
#   i += 1
# end

# p i

