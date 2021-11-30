data = File.read('06_input')

# data = <<-EXAMPLEINPUT
# abc

# a
# b
# c

# ab
# ac

# a
# a
# a
# a

# b
# EXAMPLEINPUT



groups = data.split("\n\n")
part1 = groups.sum do |group|
  group.gsub!("\n", "")
  group.chars.uniq.size
end

groups = data.split("\n\n")
part2 = groups.sum do |group|
  members = group.split("\n")
  questions = group.gsub("\n", "").chars.uniq
  questions_answered_by_all_members = questions.select do |question|
    members.all?{|member| member.include?(question)}
  end

  questions_answered_by_all_members.size
end


puts "Part 1: #{part1}"
puts "Part 2: #{part2}"