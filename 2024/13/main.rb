require_relative '../util/time'

def prep
  File.read("input", chomp: true).split("\n\n")
    .map{ |s|
      ba, bb, pr = s.split("\n").map{ _1.scan(/\d+/).map(&:to_i) }
      [ba, bb, pr]
    }
end

def solve(input, factor = 0)
  input.sum do |(bax,bay),(bbx,bby),(prx,pry)|
    b = ((prx + factor) * -bay + (pry + factor) * bax) / (bbx * -bay + bby * bax)
    a = (pry + factor - b * bby) / bay
    
    if a * bax + b * bbx == prx + factor && a * bay + b * bby == pry + factor
      a * 3 + b * 1
    else
      0
    end
  end
end

input = time("Prep", false){ prep }
time("Part 1"){ solve(input) }
time("Part 2"){ solve(input, 10000000000000) }