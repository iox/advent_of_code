lines = File.readlines('02_input')

# part1
counter = 0
lines.each do |line|
  minrange,maxrange,letter,password = line.match(/(\d+)-(\d+) ([a-z]): ([a-z]*)/).captures
  counter += 1 if password.count(letter) >= minrange.to_i && password.count(letter) <= maxrange.to_i
end
puts counter


# part2
counter = 0
lines.each do |line|
  positiona,positionb,letter,password = line.match(/(\d+)-(\d+) ([a-z]): ([a-z]*)/).captures

  positiona_match = password[positiona.to_i-1] == letter
  positionb_match = password[positionb.to_i-1] == letter

  both_match = positiona_match && positionb_match

  counter += 1 if !both_match && (positiona_match || positionb_match)
end
puts counter