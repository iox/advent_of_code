#! /usr/bin/env ruby

module Something
  DEBUG = false
  MAX_ITERATIONS = 500000
  def calculate(input)
    # Generate all possible combinations
    combinations = [0,1,2,3,4].permutation.to_a.reverse

    combinations.map{|combination| run_combination(input.clone, combination)}.max
  end

  def calculate_b(input)
    combinations = [5,6,7,8,9].permutation.to_a.reverse

    combinations.map{|combination| run_combination(input.clone, combination)}.max
  end




  def run_combination(input, combination)
    signal = 0
    combination.each do |phase|
      signal = run_intcode(input, phase, signal)
    end
    signal
  end




  def run_combination_b(input, combination)
    signal = 0
    combination.each do |phase|
      result = run_intcode(input, phase, signal)

      if result[:status] == 'END'
        raise "IT SHOULD NOT END ON THE FIRST 5 ITERATIONS!"
      end
      signal = result[:signal]
    end

    iterations = 0
    loop do
      iterations += 1
      if iterations > MAX_ITERATIONS
        raise "MAX_ITERATIONS ERROR"
      end
      result = run_intcode(input, signal, signal)
      signal = result[:signal]
      break if result[:status] == 'END'
    end

    signal
  end




  


  def run_intcode(input, phase, signal)
    puts "------------PROGRAM START (phase #{phase})  (signal #{signal})-------------"
    result = nil
    inputting_counter = 0
    iterations = 0
    pointer = 0
    loop do
      if DEBUG
        puts "\n\nIteration ##{iterations}. Pointer #{pointer}. Value #{input[pointer]}"
        puts '  ' + input.join(',')
      end

      iterations += 1
      if iterations > MAX_ITERATIONS
        puts "ERROR - iterations more than #{MAX_ITERATIONS}"
        return result
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

      puts "  Modes #{modes.inspect}" if DEBUG



      if next_instruction == 99
        if result
          puts "------------99 PROGRAM END: Result #{result}--------------"
          return {signal: result, status: 'END'}
        else
          raise "REACHED 99 WITHOUT ANY RESULT!"
        end
      else
        if result
          return {signal: result, status: 'CONTINUE'}
        end
      end





      if next_instruction == 1
        if DEBUG
          puts "  1 running a sum input[#{third_attribute_pointer}] (#{input[third_attribute_pointer]}) = input[#{first_attribute_pointer}] (#{input[first_attribute_pointer]}) + input[#{second_attribute_pointer}] (#{input[second_attribute_pointer]})"
        end

        input[third_attribute_pointer] = input[first_attribute_pointer] + input[second_attribute_pointer]

        puts "   = #{input[third_attribute_pointer]}" if DEBUG
        pointer += 4
      elsif next_instruction == 2
        if DEBUG
          puts "  2 running a multiplication [#{third_attribute_pointer}] (#{input[third_attribute_pointer]}) = input[#{first_attribute_pointer}] (#{input[first_attribute_pointer]}) * input[#{second_attribute_pointer}] (#{input[second_attribute_pointer]})"
        end

        input[third_attribute_pointer] = input[first_attribute_pointer] * input[second_attribute_pointer]

        puts "    = #{input[third_attribute_pointer]}" if DEBUG
        pointer += 4
      elsif next_instruction == 3
        if inputting_counter == 0
          input_value = phase
          inputting_counter += 1
        elsif inputting_counter == 1
          input_value = signal
        else
          raise "TODO CHANGEME to input_value = signal SHOULD NOT HAPPEN"
        end
        
        puts "  3 inputting a value #{input_value} in input[#{first_attribute_pointer}]" if DEBUG
        input[first_attribute_pointer] = input_value
        pointer += 2






      elsif next_instruction == 4
        puts '  4 outputting a value' if DEBUG
        result = input[first_attribute_pointer]
        
        pointer += 2
      







      elsif next_instruction == 5
        puts "  5 jump-if-true" if DEBUG
        if input[first_attribute_pointer] != 0
          pointer = input[second_attribute_pointer]
        else
          pointer += 3
        end
      
      elsif next_instruction == 6
        puts "  6 jump-if-false" if DEBUG
        if input[first_attribute_pointer] == 0
          pointer = input[second_attribute_pointer]
        else
          pointer += 3
        end
      
      elsif next_instruction == 7
        puts "  7 less than" if DEBUG
        if input[first_attribute_pointer] < input[second_attribute_pointer]
          input[third_attribute_pointer] = 1
        else
          input[third_attribute_pointer] = 0
        end
        pointer += 4
      
      elsif next_instruction == 8
        puts "  8 equals" if DEBUG
        if input[first_attribute_pointer] == input[second_attribute_pointer]
          input[third_attribute_pointer] = 1
        else
          input[third_attribute_pointer] = 0
        end
        pointer += 4
      else
        puts "ERROR - unknown next instruction #{next_instruction}"
        break
      end

      pointer -= pointer.size if pointer > input.size
    end

    result
  end
end


if !ARGV.include?("run")
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    include Something
    def test_calculate
      # assert_equal(43210, run_combination([3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0], [4,3,2,1,0]))
      
      # assert_equal(54321, run_combination([3,23,3,24,1002,24,10,24,1002,23,-1,23,
      #   101,5,23,23,1,24,23,23,4,23,99,0,0], [0,1,2,3,4]))

      # assert_equal(65210, run_combination([3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
      #   1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0], [1,0,4,3,2]))



      # assert_equal(43210, calculate([3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]))
      # assert_equal(54321, calculate([3,23,3,24,1002,24,10,24,1002,23,-1,23,
      #   101,5,23,23,1,24,23,23,4,23,99,0,0]))
      # assert_equal(65210, calculate([3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
      #     1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0]))
      
      assert_equal(139629729, run_combination_b([3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,
        27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5], [9,8,7,6,5]))


      assert_equal(139629729, run_combination_b([3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,
          27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5], [9,7,8,5,6]))

    end
  end

else
  include Something

  puts calculate(File.read('07_input').split(',').map(&:to_i))
  puts calculate_b(File.read('07_input').split(',').map(&:to_i))
end
