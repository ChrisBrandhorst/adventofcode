start = Time.now
input = File.read("input", chomp: true).split("\n\n").map{ _1.split }

workflows = input.first.map { |l|
  rules = l.split(/[{,}]/)
  (1..rules.size-2).each do |i|
    r = rules[i].match(/(\w)([<>])(\d+):([AR]|\w+)/).captures
    rules[i] = [r[0], r[1] == ">" ? 0 : -1, r[2].to_i, r[3]]
  end
  [rules.shift, rules]
}.to_h
parts = input.last.map{ _1.scan(/(\w)=(\d+)/).map{ |l| [l[0],l[1].to_i] }.to_h }
puts "Prep: #{Time.now - start}s"


start = Time.now

accepted = parts.select do |part|
  wf = "in"
  accept = nil

  while accept.nil?
    workflows[wf].detect do |r|
      if r.is_a?(Array)
        prp, cutd, val, goto = r
        wf = (part[prp] < val) ^ (cutd == 0) ? goto : nil
      else
        wf = r
      end
      accept = wf == "A" ? true : (wf == "R" ? false : nil)
      !accept.nil? || wf
    end
  end

  accept
end

part1 = accepted.map(&:values).flatten.sum
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now

queue = [[
  "in", {
    "x" => (1..4000), "m" => (1..4000),
    "a" => (1..4000), "s" => (1..4000)
  }
]]

accepted = []
while (wf, props = queue.pop)
  accepted << props if wf == "A"
  next if !workflows.key?(wf)

  workflows[wf].each do |r|
    if r.is_a?(Array)
      prp, cutd, val, goto = r
      cuti = val + cutd

      split_rng, cont_rng = (props[prp].begin..cuti), (cuti+1..props[prp].end)
      split_rng, cont_rng = cont_rng, split_rng if cutd == 0

      props[prp] = cont_rng
      queue.unshift([goto,props.merge(prp => split_rng)])
    else
      queue.unshift([r,props])
    end
  end
end

part2 = accepted.sum{ _1.values.map(&:size).inject(&:*) }
puts "Part 2: #{part2} (#{Time.now - start}s)"