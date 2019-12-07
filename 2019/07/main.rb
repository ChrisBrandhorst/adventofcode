require '../intcode/intcode'

input = File.read("input").split(",").map(&:to_i)

RANGE = 5
AMP_COUNT = 5

start = Time.now
signals = []
amps = (0..AMP_COUNT-1).map{ Intcode.new(input) }
(AMP_COUNT ** RANGE).times do |i|

  phases = i.to_s(RANGE).rjust(RANGE, "0").chars.map(&:to_i)
  next if phases.uniq.size < AMP_COUNT
  
  signal = 0
  amps.each_with_index do |amp,ai|
    signal = amp.reset!.with_input([phases[ai],signal]).run.output
  end
  signals << signal

end

part1 = signals.max
puts "Part 1: #{part1} (#{Time.now - start}s)"



start = Time.now
signals = []
amps.each(&:loop_mode)
(AMP_COUNT ** RANGE).times do |i|

  phases = i.to_s(RANGE).rjust(RANGE, "0").chars.map{ |c| c.to_i + RANGE }
  next if phases.uniq.size < AMP_COUNT

  amps.each_with_index{ |a,ai| a.reset!.with_input(phases[ai]) }

  signal = 0
  while true
    loop_signals = []
    amps.each do |a|
      signal = a.with_input(signal).run.output
      loop_signals << signal
    end
    break if loop_signals.uniq.size == 1
  end
  signals << loop_signals.first

end

part2 = signals.max
puts "Part 2: #{part2} (#{Time.now - start}s)"

