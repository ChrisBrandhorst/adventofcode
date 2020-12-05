input = File.read("input").split("").map(&:to_i)

PATTERN = [0, 1, 0, -1]

def calc_patterns(signal)
  out = []
  signal.each_with_index do |e,i|
    row = []
    signal.each_with_index do |a,j|
      pat_idx = (j + 1) / (i + 1)
      pat_idx = pat_idx % PATTERN.size if pat_idx > PATTERN.size - 1
      row << PATTERN[pat_idx]
    end
    out << row
  end
  out
end

def fft(signal, patterns)
  signal.each_with_index.map do |e,i|
    out = 0
    signal.each_with_index do |a,j|
      out += a * patterns[i][j]
    end
    out.abs % 10
  end
end

def part1(signal)
  patterns = calc_patterns(signal)
  100.times { signal = fft(signal, patterns) }
  signal.first(8).join
end

def part2(signal)
  100.times do
    new_signal = []
    new_signal[signal.size - 1] = signal.last
    (signal.size-2).downto(0) { |i| new_signal[i] = (signal[i] + new_signal[i+1]) % 10 }
    signal = new_signal
  end
  signal.first(8).join
end

start = Time.now
part1 = part1(input)
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
signal = input * 10000
offset = signal.first(7).join.to_i
part2 = part2( signal.last(signal.size - offset) )
puts "Part 2: #{part2} (#{Time.now - start}s)"