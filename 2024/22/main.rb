require_relative '../util/time'

def prep
  File.readlines("input", chomp: true).map(&:to_i)
end

def evolve(secret)
  secret = ((secret * 64) ^ secret) % 16777216
  secret = ((secret / 32) ^ secret) % 16777216
  secret = ((secret * 2048) ^ secret) % 16777216
end

def part1(input)
  input.sum do |secret|
    2000.times.each{ secret = evolve(secret) }
    secret
  end
end

def part2(input)
  all_seqs = Hash.new(0)

  input.each do |secret|
    prev_price = nil
    last = []
    secret_seqs = Set.new

    2000.times do |i|
      price = secret % 10
      if prev_price
        last << price - prev_price
        if last.size == 4
          unless secret_seqs.include?(last)
            all_seqs[last] += price
            secret_seqs << last
          end
          last = last.slice(1,3)
        end
      end
      prev_price = price
      secret = evolve(secret)
    end
  end

  all_seqs.values.max
end

input = time("Prep", false){ prep }
time("Part 1"){ part1(input) }
time("Part 2"){ part2(input) }