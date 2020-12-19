class Integer
  def -(other); self * other; end
  def **(other); self + other; end
end
puts File.readlines('input').inject([0,0]){ |(a,b),l| [a + eval(l.tr('*', '-')), b + eval(l.gsub('+', '**'))] }