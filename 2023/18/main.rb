require '../util/grid_points'

start = Time.now
input = File.readlines("input", chomp: true).map{ l = _1.split; [l[0], l[1].to_i, l[2][2..-2]] }
puts "Prep: #{Time.now - start}s"


def dig(instructions)
  edge_length = 0
  cur = [0,0]

  vertices = instructions.inject([]) do |vs,l|
    case l[0]
    when 'U'; nxt = [cur[0],cur[1]-l[1]]
    when 'R'; nxt = [cur[0]+l[1],cur[1]]
    when 'D'; nxt = [cur[0],cur[1]+l[1]]
    when 'L'; nxt = [cur[0]-l[1],cur[1]]
    end
    edge_length += l[1]
    vs << (cur = nxt)
  end
  
  vertices.each_cons(2).sum{ |(xa,ya),(xb,yb)| ((ya+yb) / 2) * (xa-xb) } + edge_length / 2 + 1
end


start = Time.now
part1 = dig(input)
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
INT_TO_DIR = {0=>'R',1=>'D',2=>'L',3=>'U'}
instructions = input.map{ |_,_,h| [INT_TO_DIR[h[5].to_i], h[0..4].to_i(16)] }
part2 = dig(instructions)
puts "Part 2: #{part2} (#{Time.now - start}s)"