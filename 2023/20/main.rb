start = Time.now
input = File.readlines("input", chomp: true)
puts "Prep: #{Time.now - start}s"

def build_modules(input)
  modules = input.inject({}) do |mods,l|
    nt, targets = l.split(" -> ")
    type = nt[0]
    mods[type == "b" ? nt.to_sym : nt[1..-1].to_sym] = {
      type:     type == "b" ? :broadcaster : type.to_sym,
      targets:  targets.split(", ").map(&:to_sym)
    }
    mods
  end

  modules.clone.each do |n,m|
    m[:targets].each do |t|
      modules[t] = {type: :output, targets: [], mem: {}} if !modules.key?(t)
      (modules[t][:mem] ||= {})[n] = false if modules[t][:type] == :&
    end
  end

  modules
end


def push(modules, part2_mod = nil)
  res = {false => 0, true => 0}
  pulses = [[false,:broadcaster,nil]]

  until pulses.empty?
    pulse, trgt, src = pulses.shift
    mod = modules[trgt]

    res[pulse] += 1
    res[:p2_high_inp] = src if trgt == part2_mod && pulse

    case mod[:type]
    when :broadcaster
      nxt_pulse = pulse
    when :%
      next if pulse
      nxt_pulse = mod[:on] = !mod[:on]
    when :&
      mod[:mem][src] = pulse
      nxt_pulse = !mod[:mem].all?{ _2 }
    end
    mod[:targets].each{ pulses << [nxt_pulse,_1,trgt] }
  end

  res
end


start = Time.now
modules = build_modules(input)
part1 = 1000.times.inject([0,0]){ |s,_| c = push(modules); [s[0]+c[false],s[1]+c[true]] }.inject(&:*)
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
modules = build_modules(input)
part2_mod = modules.detect{ _2[:targets].include?(:rx) }.first
high_inp = {}
1.step do |i|
  count = push(modules, part2_mod)
  if src = count[:p2_high_inp]
    high_inp[src] = i
    break if high_inp.size == modules[part2_mod][:mem].size
  end
end
part2 = high_inp.values.inject(&:lcm)
puts "Part 2: #{part2} (#{Time.now - start}s)"