#! /usr/bin/env ruby
# frozen_string_literal: true

require 'timeout'

INPUT_VALUE = 5
MAX_ITERATIONS = 100_000
DEBUG = true

module Something
  def calculate(input)
    puts '------------PROGRAM START-------------'
    iterations = 0
    pointer = 0
    loop do
      if DEBUG
        puts "\n\nIteration ##{iterations}. Pointer #{pointer}. Value #{input[pointer]}"
      end
      puts '  ' + input[pointer..pointer + 3].join(',')

      iterations += 1
      if iterations > MAX_ITERATIONS
        puts "ERROR - iterations more than #{MAX_ITERATIONS}"
        return input
      end

      if input[pointer] > 99
        next_instruction = input[pointer].digits.first
        modes = input[pointer].digits.drop(2)
      else
        next_instruction = input[pointer]
        modes = [0, 0, 0, 0]
      end

      first_attribute_pointer = modes[0] && modes[0] == 1 ? (pointer + 1) : input[pointer + 1]
      second_attribute_pointer = modes[1] && modes[1] == 1 ? (pointer + 2) : input[pointer + 2]
      third_attribute_pointer = modes[2] && modes[2] == 1 ? (pointer + 3) : input[pointer + 3]

      puts "  Modes #{modes.inspect}"

      if next_instruction == 1
        if DEBUG
          puts "  1 running a sum input[#{third_attribute_pointer}] (#{input[third_attribute_pointer]}) = input[#{first_attribute_pointer}] (#{input[first_attribute_pointer]}) + input[#{second_attribute_pointer}] (#{input[second_attribute_pointer]})"
        end

        input[third_attribute_pointer] = input[first_attribute_pointer] + input[second_attribute_pointer]

        puts "   result: #{input[third_attribute_pointer]}" if DEBUG
        pointer += 4
      elsif next_instruction == 2
        if DEBUG
          puts "  2 running a multiplication [#{third_attribute_pointer}] (#{input[third_attribute_pointer]}) = input[#{first_attribute_pointer}] (#{input[first_attribute_pointer]}) * input[#{second_attribute_pointer}] (#{input[second_attribute_pointer]})"
        end

        input[third_attribute_pointer] = input[first_attribute_pointer] * input[second_attribute_pointer]

        puts "    result: #{input[third_attribute_pointer]}" if DEBUG
        pointer += 4
      elsif next_instruction == 3
        puts "  3 inputting a value 1 in input[#{first_attribute_pointer}]" if DEBUG
        input[first_attribute_pointer] = INPUT_VALUE
        pointer += 2
      elsif next_instruction == 4
        puts '  4 outputting a value' if DEBUG
        puts input[first_attribute_pointer]
        
        pointer += 2
      







      elsif next_instruction == 5
        puts "  5 jump-if-true"
        if input[first_attribute_pointer] != 0
          pointer = input[second_attribute_pointer]
        else
          pointer += 3
        end
      
      elsif next_instruction == 6
        puts "  6 jump-if-false"
        if input[first_attribute_pointer] == 0
          pointer = input[second_attribute_pointer]
        else
          pointer += 3
        end
      
      elsif next_instruction == 7
        puts "  7 less than"
        if input[first_attribute_pointer] < input[second_attribute_pointer]
          input[third_attribute_pointer] = 1
        else
          input[third_attribute_pointer] = 0
        end
        pointer += 4
      
      elsif next_instruction == 8
        puts "  8 equals"
        if input[first_attribute_pointer] == input[second_attribute_pointer]
          input[third_attribute_pointer] = 1
        else
          input[third_attribute_pointer] = 0
        end
        pointer += 4

      elsif next_instruction == 99
        puts '------------99 PROGRAM END--------------'
        break
      else
        puts "ERROR - unknown next instruction #{next_instruction}"
        break
      end

      pointer -= pointer.size if pointer > input.size
    end

    input
  end
end

if !ARGV.include?('run')
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    include Something
    def test_calculate
      # assert_equal([1,9,10,70,2,3,11,0,99,30,40,50], calculate_first_step([1,9,10,3,2,3,11,0,99,30,40,50]))
      assert_equal([3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50], calculate([1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]))
      assert_equal([2, 0, 0, 0, 99], calculate([1, 0, 0, 0, 99]))
      assert_equal([2, 3, 0, 6, 99], calculate([2, 3, 0, 3, 99]))
      assert_equal([2, 4, 4, 5, 99, 9801], calculate([2, 4, 4, 5, 99, 0]))
      assert_equal([30, 1, 1, 4, 2, 5, 6, 0, 99], calculate([1, 1, 1, 4, 99, 5, 6, 0, 99]))
    end
  end

else
  include Something

  input = File.read('05_input').split(',').map(&:to_i)

  calculate(input)

end
