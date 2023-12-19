start = Time.now
input = File.read("input", chomp: true).split("\n\n").map{ _1.split }

workflows = input.first.map {
  acc = _1.index("{")
  rules = _1[acc+1..._1.size-1].split(",")
  rules = rules.map { |r|
    caps = r.match(/(\w)(\>|\<)(\d+):([A-Za-z]+)/)
    caps ? caps.captures : r
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
    wf = workflows[wfk]
    wf.detect do |r|
      nxt = nil
      if r.is_a?(Array)
        prop, comp, val, goto = r
        ok = (part[prop].to_i < val.to_i && comp == "<") || (part[prop].to_i > val.to_i && comp == ">")
        nxt = goto if ok
      else
        nxt = r
      end

      if nxt == "A"
        accept = true
      elsif nxt == "R"
        accept = false
        true
      elsif nxt
        wfk = nxt
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

queue = [{
  "wf" => "in",
  "x" => (1..4000),
  "m" => (1..4000),
  "a" => (1..4000),
  "s" => (1..4000)
}]
accepted = []

def new_part(old_part, goto, prop, range)
  {
    "wf" => goto,
    "x" => prop == "x" ? range : old_part["x"].clone,
    "m" => prop == "m" ? range : old_part["m"].clone,
    "a" => prop == "a" ? range : old_part["a"].clone,
    "s" => prop == "s" ? range : old_part["s"].clone
  }
end

while part = queue.pop
  workflows[part["wf"]].each do |r|

    if r.is_a?(Array)
      prop, comp, val, goto = r
      val = val.to_i

      if comp == "<"
        part_to_wf = new_part(part, goto, prop, (part[prop].begin..val-1) )
        part[prop] = (val..part[prop].end)
      elsif comp == ">"
        part_to_wf = new_part(part, goto, prop, (val+1..part[prop].end))
        part[prop] = (part[prop].begin..val)
      end

      if part_to_wf["wf"] == "A"
        accepted << part_to_wf
      elsif part_to_wf["wf"] != "R"
        queue.unshift(part_to_wf)
      end

    elsif r == "A"
      accepted << part
    elsif r != "R"
      part["wf"] = r
      queue.unshift(part)
    end

  end

end

part2 = accepted.sum{ |a| a["x"].size * a["m"].size * a["a"].size * a["s"].size }
puts "Part 2: #{part2} (#{Time.now - start}s)"