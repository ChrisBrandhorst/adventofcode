input = File.readlines("input").map{ |i| i.gsub("\n", "").split(" => ") }

start = ".#./..#/###"

def variants(s)
  a = s.split("/").map{|i|i.split("")}
  base = [
    a,
    a.map(&:reverse),
    a.transpose,
    a.transpose.reverse
  ].map{ |i| i.map(&:join).join("/") }
  (base + base.map(&:reverse)).uniq
end

rules = input.inject({}) do |c,v|
  variants(v[0]).each{ |i| c[i] = v[1] }
  c
end


