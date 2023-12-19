start = Time.now
input = File.read("input", chomp: true).split("\n\n").map{ _1.split }

workflows = input.first.map {
  acc = _1.index("{")
  rules = _1[acc+1..._1.size-1].split(",").map { |r|
    caps = r.match(/(\w)(\>|\<)(\d+):([A-Za-z]+)/)
    if caps
      ret = caps.captures
      ret[1] = ret[1] == ">" ? 0 : -1
      ret[2] = ret[2].to_i
      ret
    else
      r
    end
  }
  [_1[0,acc], rules]
}.to_h

parts = input.last.map{ _1.scan(/(\w=\d+)/).map{ |l| l = l.first.split("="); [l[0],l[1].to_i] }.to_h }

puts "Prep: #{Time.now - start}s"


start = Time.now

accepted = parts.select do |part|
  wfk = "in"
  accept = nil

  while accept.nil?
    workflows[wfk].detect do |r|
      if r.is_a?(Array)
        prop, comp, val, goto = r
        wfk = (part[prop] < val) ^ (comp == 0) ? goto : nil
      else
        wfk = r
      end
      accept = wfk == "A" ? true : (wfk == "R" ? false : nil)
      !accept.nil? || wfk
    end
  end

  accept
end

part1 = accepted.map(&:values).flatten.sum
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now

queue = [{
  "wf" => "in",
  "x" => (1..4000), "m" => (1..4000),
  "a" => (1..4000), "s" => (1..4000)
}]

accepted = []
while part = queue.pop
  wfk = part["wf"]
  accepted << part if wfk == "A"
  next if !workflows.key?(wfk)

  workflows[wfk].each do |r|
    if r.is_a?(Array)
      prop, cutd, val, goto = r

      cuti = val + cutd
      split_rng, cont_rng = (part[prop].begin..cuti), (cuti+1..part[prop].end)
      split_rng, cont_rng = cont_rng, split_rng if cutd == 0

      part[prop] = cont_rng

      split_part = part.clone
      split_part["wf"] = goto
      split_part[prop] = split_rng
      queue.unshift(split_part)
    else
      part["wf"] = r
      queue.unshift(part)
    end
  end
end

part2 = accepted.sum{ |a| a["x"].size * a["m"].size * a["a"].size * a["s"].size }
puts "Part 2: #{part2} (#{Time.now - start}s)"