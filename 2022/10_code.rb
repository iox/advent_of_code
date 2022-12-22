instructions = []


cycle = 0
x = 1
current_instruction = nil
instructions = File.read('10_input').split("\n")

total = 0

240.times do
  print "\n" if cycle % 40 == 0
  if x == cycle%40 || x == cycle%40 + 1 || x == cycle%40 - 1
    print "#"
  else
    print " "
  end

  cycle += 1
  if current_instruction == nil
    current_instruction = instructions.shift
  end

  if [20,60,100,140,180,220].include?(cycle)
    # puts "End of cycle #{cycle} with X #{x} and current_instruction #{current_instruction}. Signal strength is #{cycle * x}"
    total += (cycle * x)
  end

  if current_instruction == "noop"
    current_instruction = nil
  elsif current_instruction[0,4] == "ADDX"
    x += current_instruction.split(" ")[1].to_i
    current_instruction = nil
  elsif current_instruction[0,4] == "addx"
    current_instruction = "ADDX " + current_instruction.split(" ")[1]
  end
 
end

puts "\n\nSUM: #{total}"


# noop
# addx 3
# addx -5
# -5
# Execution of this program proceeds as follows:
# - At the start of the first cycle, the noop instruction begins
# execution. During the first cycle, X is 1. After the first cycle, the
# noop instruction finishes execution, doing nothing.
# - At the start of the second cycle, the addx 3 instruction begins
# execution. During the second cycle, X is still 1.
# - During the third cycle, X is still 1. After the third cycle, the
# addx 3 instruction finishes execution, setting X to 4.
# - At the start of the fourth cycle, the addx -5 instruction begins
# execution. During the fourth cycle, X is still 4.
# - During the fifth cycle, X is still 4. After the fifth cycle, the
# addx -5 instruction finishes execution, setting X to -1.
