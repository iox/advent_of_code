template_string,rules_lines = File.read('14_input').split("\n\n")

template = template_string.chars

rules = {}

rules_lines.split("\n").each do |line|
  pair,insert = line.split(" -> ")
  rules[pair] = insert
end

# A hash containing pairs as keys, and number of pairs as values
pairs = Hash.new(0)

template.each_cons(2).each do |a,b|
  pairs["#{a}#{b}"] += 1
end


40.times do

  new_pairs = pairs.dup

  pairs.each do |pair,amount|
    to_insert = rules[pair]

    first_char = pair.chars[0]
    second_char = pair.chars[1]

    first_pair = [first_char, to_insert].join
    second_pair = [to_insert, second_char].join
    
    new_pairs[pair] -= amount
    new_pairs[first_pair] += amount
    new_pairs[second_pair] += amount
  end
  pairs = new_pairs
end
# puts "\n\n"
# # puts template.join
# puts pairs.inspect


char_map = {}
pairs.each do |pair, amount|
  pair.chars.each do |char|
    char_map[char] ||= 0
    char_map[char] += amount
  end
end

puts char_map.inspect

maximum =  (char_map.values.max + 1) / 2
minimum = (char_map.values.min + 1) / 2

puts "\n\n"
puts maximum
puts minimum
puts maximum - minimum

