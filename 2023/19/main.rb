start = Time.now
input = File.read("input", chomp: true).split("\n\n")
  .map{ _1.split }

workflows = input.first.map {
  acc = _1.index("{")
  rules = _1[acc+1..._1.size-1].split(",")
  rules = rules.map { |r|
    caps = r.match(/(\w)(\>|\<)(\d+):([A-Za-z]+)/)
    if caps
      caps.captures
    else
      r
    end
  }
  [_1[0,acc], rules]
}.to_h


parts = input.last.map {
  _1.scan(/(\w=\d+)/).map{ |l| l = l.first.split("="); [l[0],l[1].to_i] }.to_h
}

puts "Prep: #{Time.now - start}s"

start = Time.now


accepted = parts.select do |part|
  wfk = "in"
  accept = nil
  # puts "Part: #{part}"
  while accept.nil?
    wf = workflows[wfk]
    # puts "  Workflow: #{wf}"
    wf.detect do |r|
      # puts "    Rule: #{r}"
      nxt = nil
      if r.is_a?(Array)
        prop, comp, val, goto = r
        ok = (part[prop].to_i < val.to_i && comp == "<") || (part[prop].to_i > val.to_i && comp == ">")
        nxt = goto if ok
      else
        nxt = r
      end

      # puts "--> #{nxt}"
      if nxt == "A"
        accept = true
        true
      elsif nxt == "R"
        accept = false
        true
      elsif nxt
        wfk = nxt
        true
      else
        false
      end

    end

  end

  accept
end

part1 = accepted.map(&:values).flatten.sum
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = nil
puts "Part 2: #{part2} (#{Time.now - start}s)"