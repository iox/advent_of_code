# Create a parser for the stacks
INPUT = File.read('05_input')


def parse_input
  stacks = []

  INPUT.split("\n 1")[0].split("\n").each do |row|
    10.times.with_index do |i|
      offset = (i*4) + 1
      crate = row[offset]
      if crate && crate != " "
        stacks[i+1] ||= []
        stacks[i+1].unshift crate
      end
    end
  end
  stacks

end



# Part 1
stacks = parse_input
INPUT.split("\n\n")[1].split("\n").each do |instruction|
  matches = instruction.match(/move (\d+) from (\d+) to (\d+)/)
  amount = matches[1].to_i
  from = matches[2].to_i
  to = matches[3].to_i

  amount.times do 
    stacks[to] << stacks[from].pop
  end
end
puts stacks.compact.map(&:last).join



# Part 2
stacks = parse_input
INPUT.split("\n\n")[1].split("\n").each do |instruction|
  matches = instruction.match(/move (\d+) from (\d+) to (\d+)/)
  amount = matches[1].to_i
  from = matches[2].to_i
  to = matches[3].to_i

  stacks[to] += stacks[from].pop(amount)
end
puts stacks.compact.map(&:last).join
