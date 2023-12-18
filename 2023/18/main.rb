start = Time.now
input = File.readlines("input", chomp: true).map{ l = _1.split; [l[0], l[1].to_i, l[2][2..-2]] }
puts "Prep: #{Time.now - start}s"


def dig(instructions)
  edge_length = 0

  vertices = instructions.inject([[0,0]]) do |vs,(dir,el)|
    edge_length += el
    cur = vs.last
    vs << case dir
      when 'U'; [cur[0],cur[1]-el]
      when 'R'; [cur[0]+el,cur[1]]
      when 'D'; [cur[0],cur[1]+el]
      when 'L'; [cur[0]-el,cur[1]]
      end
  end
  
  vertices.each_cons(2).sum{ |(xa,ya),(xb,yb)| ((ya+yb) / 2) * (xa-xb) } + edge_length / 2 + 1
end


start = Time.now
part1 = dig(input)
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
INT_TO_DIR = {0=>'R',1=>'D',2=>'L',3=>'U'}
part2 = dig( input.map{ |_,_,h| [INT_TO_DIR[h[5].to_i], h[0..4].to_i(16)] } )
puts "Part 2: #{part2} (#{Time.now - start}s)"