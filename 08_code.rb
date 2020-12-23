
class Computer
  attr_reader :accumulator, :index, :executed_lines, :state
  def initialize(lines)
    @lines = lines
    @index = 0
    @accumulator = 0
    @executed_lines = []
    @state = "waiting"
  end

  def run
    @state = "running"
    loop do
      line = @lines[@index]
      if line.nil?
        @state = "finished"
        break
      end
      if !execute_line(line)
        break
      end
    end
  end

  def execute_line(line)
    code, value = line.split(" ")  
    if @executed_lines.include?(index)
      @state = "ran_twice_error"
      return false
    end
    @executed_lines << @index

    case code
    when 'nop'
      @index += 1
    when 'acc'
      @accumulator += value.to_i
      @index += 1
    when 'jmp'
      @index += value.to_i
    end
    return true
  end
end


def part1(data)
  lines = data.split("\n")

  computer = Computer.new(lines)
  computer.run
  return computer.accumulator
end









def part2(data)
  lines = data.split("\n")

  lines_permutations = [lines]

  lines.each_with_index do |line, index|
    if line.include?("jmp")
      alternative = lines.dup
      alternative[index] = line.gsub("jmp", "nop")
      lines_permutations << alternative
    elsif line.include?("nop")
      alternative = lines.dup
      alternative[index] = line.gsub("jmp", "nop")
      lines_permutations << alternative
    end
  end

  lines_permutations.each do |lines|
    computer = Computer.new(lines)
    computer.run
    if computer.state == 'finished'
      return computer.accumulator
    end
  end




  # # My problem: I am testing all of the possible combinations, that's why I am building this complex graph solution!!!
  # # I actually only need to do it once. There are only 300 possibilities.
  # first_code, first_value = lines[0].split(" ")
  # queue = [{executed_lines: [], code: first_code, value: first_value, index: 0, accumulator: 0}]
  
  # loop do
  #   raise "EMPTY QUEUE" if queue.size == 0

  #   instruction = queue.shift
  #   break instruction[:accumulator] if instruction[:code].nil?
  #   next if instruction[:executed_lines].include?(instruction[:index])
    

  #   case instruction[:code]
  #   when 'nop', 'jmp'
  #     # NOP
  #     next_index = instruction[:index] + 1
  #     next_instruction = lines[next_index]
  #     next_code = next_instruction ? next_instruction.split(" ")[0] : nil
  #     next_value = next_instruction ? next_instruction.split(" ")[1] : nil
  #     queue << {
  #       executed_lines: instruction[:executed_lines] + [instruction[:index]],
  #       index: next_index,
  #       accumulator: instruction[:accumulator],
  #       code: next_code,
  #       value: next_value
  #     }

  #     # JMP
  #     next_index = instruction[:index] + instruction[:value].to_i
  #     next_instruction = lines[next_index]
  #     next_code = next_instruction ? next_instruction.split(" ")[0] : nil
  #     next_value = next_instruction ? next_instruction.split(" ")[1] : nil
  #     queue << {
  #       executed_lines: instruction[:executed_lines] + [instruction[:index]],
  #       index: next_index,
  #       accumulator: instruction[:accumulator],
  #       code: next_code,
  #       value: next_value
  #     }


  #   when 'acc'
  #     next_index = instruction[:index] + 1
  #     next_instruction = lines[next_index]
  #     next_code = next_instruction ? next_instruction.split(" ")[0] : nil
  #     next_value = next_instruction ? next_instruction.split(" ")[1] : nil
  #     queue << {
  #       executed_lines: instruction[:executed_lines] + [instruction[:index]],
  #       index: instruction[:index] + 1,
  #       accumulator: instruction[:accumulator] + instruction[:value].to_i,
  #       code: next_code,
  #       value: next_value
  #     }
  #   end
  # end

end



















data = File.read('08_input')
puts "Part 1: #{part1(data)}"
puts "Part 2: #{part2(data)}"


def example_data
<<-EXAMPLEINPUT
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
EXAMPLEINPUT
end
  

if ARGV.include?('test')
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    def test_part1
      assert_equal(5, part1(example_data))
    end
    def test_part2
      assert_equal(8, part2(example_data))
    end
  end

end