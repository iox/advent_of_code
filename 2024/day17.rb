def parse(input)
  registers_part, program_part = input.split("\n\n")

  registers = registers_part.split("\n").map do |line|
    line.split(": ")[1].to_i
  end

  program = program_part.sub("Program: ", "").split(",").map(&:to_i)

  [registers, program]
end



def process(registers, program)
  instruction_pointer = 0
  output = []

  until instruction_pointer >= program.size
    current_instruction = program[instruction_pointer]

    if current_instruction == 0
      power_amount = get_combo(instruction_pointer, registers, program)
      divide_by = 2 ** power_amount
      registers[0] = registers[0] / divide_by
    
    elsif current_instruction == 6
      power_amount = get_combo(instruction_pointer, registers, program)
      divide_by = 2 ** power_amount
      registers[1] = registers[0] / divide_by

    elsif current_instruction == 7
      power_amount = get_combo(instruction_pointer, registers, program)
      divide_by = 2 ** power_amount
      registers[2] = registers[0] / divide_by

    elsif current_instruction == 1
      registers[1] = registers[1] ^ program[instruction_pointer + 1]

    elsif current_instruction == 2
      combo_value = get_combo(instruction_pointer, registers, program)
      registers[1] = combo_value % 8

    elsif current_instruction == 3
      if registers[0] != 0
        jump_address = program[instruction_pointer + 1]
        instruction_pointer = jump_address - 2
      end

    elsif current_instruction == 4
      registers[1] = registers[1] ^ registers[2]

    elsif current_instruction == 5
      combo_value = get_combo(instruction_pointer, registers, program)
      output << combo_value % 8
    end

    instruction_pointer += 2
  end

  output
end


def get_combo(pointer, registers, program)
  instruction = program[pointer+1]
  raise "STOP" if instruction.nil?

  return program[pointer+1] if instruction < 4
  return registers[instruction-4] if instruction < 7

  raise "SOMETHING WENT VERY WRONG"
end

def part1(input)
  registers, program = parse(input)

  process(registers, program).join(",")
end


def part2(input)
  registers, program = parse(input)

  valid_numbers = [0]
  program.size.times.each do |i|
    # This is the key. We start with a very simple program, with just one instruction
    # Then we find which values of the first register work
    # Then we add another instruction. 
    # The only values that work are the ones that worked before
    smaller_program = program.last(i+1)
    # puts "smaller_program #{smaller_program.inspect} and valid_numbers #{valid_numbers.inspect}"

    new_valid_numbers = []

    valid_numbers.each do |n|
      # This is a bit of dark magic. From reddit
      # Figured out that register A is divided by 8 every run and 0-7 give single digit outputs. So the final(nth) output is the output from the quotient of A divided by 8^(n-1). Knowing that, find out which (if any) of 0-7 gives the right number. Multiply those by 8, add 0-7 to each, and rerun to find which gives the right final two outputs. Repeat until there's a list of numbers that give all of the right outputs and take the smallest.
      base_number = 8 * n
      (0..7).each do |offset|
        registers = [base_number + offset, 0, 0]
        if process(registers, program) == smaller_program
          # puts "Found #{base_number + offset}"
          new_valid_numbers << base_number + offset
        else
          # puts "--Not found #{base_number + offset}"
        end
      end
    end

    # puts "new_valid_numbers #{new_valid_numbers.inspect}"
    valid_numbers = new_valid_numbers
  end

  result = valid_numbers.min

  result
end


puts part1(File.read("day17.txt"))
puts part2(File.read("day17.txt"))



require 'minitest/autorun'
require 'minitest/color'

class TestDay3 < Minitest::Test
  def sample
    <<-EOF
    Register A: 729
    Register B: 0
    Register C: 0

    Program: 0,1,5,4,3,0
    EOF
  end

  def sample_part2
    <<-EOF
    Register A: 2024
    Register B: 0
    Register C: 0

    Program: 0,3,5,4,3,0
    EOF
  end

  def stupid_sample
    <<-EOF
    Register A: 0
    Register B: 0
    Register C: 0

    Program: 0,3,5,4,3,0
    EOF
  end

  def another_stupid_sample
    <<-EOF
    Register A: 0
    Register B: 0
    Register C: 0

    Program: 5,4,3,0
    EOF
  end


  def test_part1
    assert_equal 729, parse(sample)[0][0]
    assert_equal [0,1,5,4,3,0], parse(sample)[1]

    assert_equal "4,6,3,5,6,3,5,2,1,0", part1(sample)

    assert_equal "0", part1(stupid_sample)
    assert_equal "0", part1(another_stupid_sample)
  end

  def test_part2
    assert_equal 117440, part2(sample_part2)
  end
end