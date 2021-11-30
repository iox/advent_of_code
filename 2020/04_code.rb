data = File.read('04_input')

passports = data.split("\n\n")
required_fields = %w{ecl pid eyr hcl byr iyr hgt}

part1 = passports.count do |passport|
  required_fields.all? do |field|
    passport.include?(field)
  end
end





part2 = passports.count do |passport|
  passport.gsub!("\n", " ")
  #   byr (Birth Year) - fou r digits; at least 1920 and at most 2002.
  byr = passport.split("byr:")[1]&.split&.fetch(0)
  next if byr.nil? || byr.to_i < 1920 || byr.to_i > 2002

  # iyr (Issue Year) - four digits; at least 2010 and at most 2020.
  iyr = passport.split("iyr:")[1]&.split&.fetch(0)
  next if iyr.nil? || iyr.to_i < 2010 || iyr.to_i > 2020

  # eyr (Expiration Year) - four digits; at least 2020 and at most 2030.  
  eyr = passport.split("eyr:")[1]&.split&.fetch(0)
  next if eyr.nil? || eyr.to_i < 2020 || eyr.to_i > 2030

  # hgt (Height) - a number followed by either cm or in:
  #     If cm, the number must be at least 150 and at most 193.
  #     If in, the number must be at least 59 and at most 76.
  hgt = passport.split("hgt:")[1]&.split&.fetch(0)
  next if hgt.nil?
  if hgt.include?("cm")
    next if hgt.to_i < 150 || hgt.to_i > 193
  elsif hgt.include?("in")
    next if hgt.to_i < 59 || hgt.to_i > 76
  else
    next
  end

  # hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
  hcl = passport.split("hcl:")[1]&.split&.fetch(0)
  next if hcl.nil?
  next unless hcl.match?(/#[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]/)

  # ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
  ecl = passport.split("ecl:")[1]&.split&.fetch(0)
  next unless %w{amb blu brn gry grn hzl oth}.include?(ecl)

  # pid (Passport ID) - a nine-digit number, including leading zeroes.
  pid = passport.split("pid:")[1]&.split&.fetch(0)
  next if pid.nil? || pid.size != 9

  true
end


puts "Part 1: #{part1}"
puts "Part 2: #{part2}"


