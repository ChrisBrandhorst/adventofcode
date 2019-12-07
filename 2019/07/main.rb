require '../intcode/intcode'

input = File.read("input").split(",").map(&:to_i)

RANGE = 5
AMPS = 5

amps = (0..AMPS-1).map{ Intcode.new(input) }

start = Time.now
signals = []
(AMPS ** RANGE).times do |i|

  phases = i.to_s(RANGE).rjust(RANGE, "0").chars.map(&:to_i)
  next if phases.uniq.size < AMPS
  
  outputs = []

  amps.each_with_index do |amp,i|
    outputs << amp.with_input([phases[i],outputs.last || 0]).run
  end
  signals << outputs.last

end

part1 = signals.max
puts "Part 1: #{part1} (#{Time.now - start}s)"



start = Time.now
signals = []
(AMPS ** RANGE).times do |i|

  amps = (0..AMPS-1).map{ Intcode.new(input) }
  phases = i.to_s(RANGE).rjust(RANGE, "0").chars.map{ |c| c.to_i + RANGE }
  next if phases.uniq.size < AMPS

  # phases = "98765".split('').map(&:to_i)

  amps.each_with_index{ |a,i| a.add_input(phases[i]) }

  signal = 0
  while true
    loop_signals = []
    amps.each do |a|
      signal = a.add_input(signal).run(false)
      loop_signals << signal
    end
    break if loop_signals.uniq.size == 1
  end

  signals << loop_signals.first

end

part2 = signals.max
puts "Part 2: #{part2} (#{Time.now - start}s)"

