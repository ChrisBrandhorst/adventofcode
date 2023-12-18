start = Time.now
input = File.readlines("input", chomp: true).map{ l = _1.split; [l[0], l[1].to_i, l[2][2..-2]] }
puts "Prep: #{Time.now - start}s"


def dig(instructions)
  edge_length, cur = 0, [0,0]

  area = instructions.inject(0) do |a,(dir,el)|
    xa, ya = cur
    xb, yb = cur = case dir
      when 'U'; [xa, ya-el]
      when 'R'; [xa+el, ya]
      when 'D'; [xa, ya+el]
      when 'L'; [xa-el, ya]
    end
    edge_length += el
    a + ((ya+yb) / 2) * (xa-xb)
  end
  
  area + edge_length / 2 + 1
end


start = Time.now
part1 = dig(input)
puts "Part 1: #{part1} (#{Time.now - start}s)"


start = Time.now
INT_TO_DIR = {0=>'R',1=>'D',2=>'L',3=>'U'}
part2 = dig( input.map{ |_,_,h| [INT_TO_DIR[h[5].to_i], h[0..4].to_i(16)] } )
puts "Part 2: #{part2} (#{Time.now - start}s)"