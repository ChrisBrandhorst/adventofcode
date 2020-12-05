start = Time.now
input = File.read("input")
  .split("\n\n")
  .map{ |b|
    b.split(/\s/)
      .map{ |p| p.split(":") }
      .to_h.transform_keys(&:to_sym)
  }
puts "Prep: #{Time.now - start}s"

def is_valid_1(pp)
  pp.keys.size == 8 ||
  (pp.keys.size == 7 && pp[:cid].nil?)
end

def is_valid_2(pp)
  is_valid_1(pp) &&
  pp[:byr].to_i.between?(1920, 2002) &&
  pp[:iyr].to_i.between?(2010, 2020) &&
  pp[:eyr].to_i.between?(2020, 2030) &&
  (
    pp[:hgt].end_with?("cm") && pp[:hgt].to_i.between?(150, 193) ||
    pp[:hgt].end_with?("in") && pp[:hgt].to_i.between?(59, 76)
  ) &&
  pp[:hcl].match?(/^#[0-9a-f]{6}$/) &&
  pp[:ecl].match?(/^(amb|blu|brn|gry|grn|hzl|oth)$/) &&
  pp[:pid].match?(/^\d{9}$/)
end

start = Time.now
part1 = input.count{ |p| is_valid_1(p) }
puts "Part 1: #{part1} (#{Time.now - start}s)"

start = Time.now
part2 = input.count{ |p| is_valid_2(p) }
puts "Part 2: #{part2} (#{Time.now - start}s)"