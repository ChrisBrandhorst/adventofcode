require 'set'

# Data prep
data = File.readlines("input").map{ |l| l.chomp.split('') }
$c_width = data.first.size
$c_height = data.size
collection = data.flatten

def output(c)
  c.each_slice($c_width).map{ |s| s.join('') }.join("\n")
end

def get_acre(c,i)
  i < 0 ? nil : c[i]
end

def get_adjecent(c,i)
  look_left   = i % $c_width == 0 ? 0 : 1
  look_right  = (i + 1) % $c_width == 0 ? 0 : 1
  look_top    = i >= $c_width
  look_bottom = i <= $c_width * ($c_height - 1) - 1
  
  adj = {'#' => 0, '|' => 0, '.' => 0}
  if look_top
    adj[ c[i - $c_width - 1] ] += 1 if look_left == 1
    adj[ c[i - $c_width] ] += 1
    adj[ c[i - $c_width + 1] ] += 1 if look_right == 1
  end
  adj[c[i-1]] += 1 if look_left == 1
  adj[c[i+1]] += 1 if look_right == 1
  if look_bottom
    adj[ c[i + $c_width - 1] ] += 1 if look_left == 1
    adj[ c[i + $c_width] ] += 1
    adj[ c[i + $c_width + 1] ] += 1 if look_right == 1
  end

  adj
end

def new_acre_value(c,a,i)
  current = a
  adjecent = get_adjecent(c,i)

  if current == '.' && adjecent['|'] >= 3
    '|'
  elsif current == '|' && adjecent['#'] >= 3
    '#'
  elsif current == '#' 
    adjecent['#'] >= 1 && adjecent['|'] >= 1 ? '#' : '.'
  else
    current
  end
end

def calc_resource(collection)
  trees = collection.count{ |a| a == '|'}
  lumber = collection.count{ |a| a == '#'}
  trees * lumber
end

def run(minutes, collection)
  
  seen_resources = []
  seen_previous = false

  minutes.times do |i|

    new_collection = collection.dup
    collection.each_with_index do |a,i|
      new_acre = new_acre_value(collection,a,i)
      new_collection[i] = new_acre
    end

    res = calc_resource(new_collection)
    seen_idx = seen_resources.index(res)

    if !seen_idx.nil?
      if seen_previous
        # We have a pattern!
        pattern_size = i - seen_idx
        pattern_idx = i - pattern_size - 1
        rest = (minutes - 1- pattern_idx) % pattern_size
        return seen_resources[pattern_idx + rest]
      end
      seen_previous = true
    else
      seen_previous = false
    end

    seen_resources[i] = res
    collection = new_collection
  end

  calc_resource(collection)
end

puts "Part 1: #{run(10,collection)}"
puts "Part 2: #{run(1000000000,collection)}"