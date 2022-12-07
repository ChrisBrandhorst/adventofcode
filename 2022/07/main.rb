start = Time.now
input = File.readlines("input", chomp: true)

pwd = nil
folders = input.inject([]) do |fs,i|
  if i[/^\$ cd (.+)/]
    if $1 == ".."
      pwd = pwd[:parent]
    else
      folder = {parent: pwd, children: []}
      fs << folder
      pwd[:children] << folder if pwd
      pwd = folder
    end
  elsif i[/^(\d+)/]
    pwd[:children] << $1.to_i
  end
  fs
end

def get_size(file)
  file.is_a?(Integer) ? file : file[:children].sum{ get_size(_1) }
end

folder_sizes = folders.map{ get_size(_1) }
puts "Prep: #{Time.now - start}s"

start = Time.now
part1 = folder_sizes.select{ _1 <= 100000 }.sum
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = folder_sizes.select{ 70000000 - folder_sizes.first + _1 > 30000000 }.min
puts "Part 2: #{part2} (#{Time.now - start}s)"