sacks = File.read('03_input').split("\n")

priorities = [" "] + ("a".."z").to_a + ("A".."Z").to_a



score = 0
sacks.each do |sack|
  solved = false
  half_index = sack.length / 2
  first_half = sack.slice(0, half_index)
  second_half = sack.slice(half_index, sack.length)

  first_half.chars.each do |c|
    next if solved
    if second_half.include?(c)
      puts "#{first_half} and #{second_half} share the char #{c}"
      score += priorities.index(c)
      solved = true
    end
  end
end

puts score



score = 0
sacks.each_slice(3) do |group|
  group.join.chars.uniq.each do |c|
    if group.all?{|sack| sack.include?(c)}
      puts "#{c} was found in all 3 rucksacks"
      score += priorities.index(c)
    end
  end
end
puts score