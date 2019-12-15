REACTION_FORMAT = /(\d+ \w+)/
FUEL = "FUEL"
ORE = "ORE"
TRILLION = 1000000000000

input = File.readlines("input")

reactions = input.inject({}) do |res, line|
  sources = line.scan(REACTION_FORMAT).flatten.map do |str|
    parts = str.split(" ")
    { type: parts[1].to_s, amount: parts[0].to_i }
  end
  target = sources.pop
  res[target[:type]] = { target: target, sources: sources }
  res
end

def part1(fuel_target, reactions)
  requirements = {}
  requirements[FUEL] = fuel_target
  waste = {}

  until requirements.size == 1 && requirements.keys.first == ORE

    req_type, req_amount = requirements.shift
    (requirements[req_type] = req_amount) && next if req_type == ORE
    reaction = reactions[req_type]

    mult = (req_amount.to_f / reaction[:target][:amount]).ceil

    reaction[:sources].each do |s|
      req_amount_mult = s[:amount] * mult
      if (waste[s[:type]] || 0) > 0
        r = [waste[s[:type]] || 0, req_amount_mult].min
        waste[s[:type]] -= r
        req_amount_mult -= r
      end
      requirements[s[:type]] ||= 0
      requirements[s[:type]] += req_amount_mult
    end

    w = reaction[:target][:amount] * mult - req_amount
    if w > 0
      waste[req_type] ||= 0
      waste[req_type] += w
    end

  end

  requirements[ORE]
end

def part2(ore_available, start, reactions)
  divider = start
  2.step do |i|
    ore = part1(i, reactions).to_f / i
    break if (ore - divider).abs < 0.1
    divider = ore
  end

  (TRILLION / divider.to_i).step do |i|
    return i - 1 if part1(i, reactions) > 1000000000000
  end
end

start = Time.now
part1 = part1(1, reactions)
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = part2(TRILLION, part1, reactions)
puts "Part 2: #{part2} (#{Time.now - start}s)"