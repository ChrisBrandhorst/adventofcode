require_relative '../util/time'

def build_pad(str)
  str.scan(/.{3}/).map(&:chars)
    .each_with_index.inject({}){ |r,(row,y)|
      row.each_with_index.inject(r){ |r,(v,x)|
        r[v] = [x,y] if v != " "; r
      }
    }
end

def prep
  @numpad = build_pad("789456123 0A")
  @controlpad = build_pad(" ^A<v>")
  File.readlines("input", chomp: true)
end

@gb_mem = {}
def get_best_steps(pad, ab)
  return @gb_mem[ab] if @gb_mem[ab]

  a, b = ab
  ac, bc = pad[a], pad[b]
  dx, dy = bc[0] - ac[0], bc[1] - ac[1]

  xs = (dx > 0 ? ">" : "<") * dx.abs
  ys = (dy > 0 ? "v" : "^") * dy.abs

  # If we need to go right and we can go vertical then right
  # (there is no hole at the turning point of this path)
  if dx > 0 && pad.values.include?([ac[0], bc[1]])
    res = ys + xs
  # Else if we can go horizontal, then vertical
  # (same no hole check)
  elsif pad.values.include?([bc[0], ac[1]])
    res = xs + ys
  # Other situations. Just one apparently, go left from A: A<
  else
    res = ys + xs
  end

  @gb_mem[ab] = res + "A"
end

@it_mem = {}
def iterate(code, pad, its_rem)
  mk = [code,pad,its_rem]
  return @it_mem[mk] if @it_mem[mk]

  # Go through each consecutive pair of button presses
  @it_mem[mk] = ("A" + code).chars.each_cons(2).inject(0) do |l,ab|
    # Get the best (min length) steps to do that move
    steps = get_best_steps(pad, ab)
    # If we are at the end of the iterations, just add the size of the final steps
    # Otherwise, calculate what the next robot has to do for these steps
    l + (its_rem == 0 ? steps.size : iterate(steps, @controlpad, its_rem - 1))
  end
end

def calc(codes, its)
  codes.sum{ iterate(_1, @numpad, its) * _1[0..-1].to_i }
end

codes = time("Prep", false){ prep }
time("Part 1"){ calc(codes, 2) }
time("Part 2"){ calc(codes, 25) }