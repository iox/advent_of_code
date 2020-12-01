#! /usr/bin/env ruby
# frozen_string_literal: true

load 'intcode.rb'

module Something

  def calculate(input)
    # Generate all possible combinations
    combinations = [0, 1, 2, 3, 4].permutation.to_a.reverse

    combinations.map do |combination|
      run_combination(input.clone, combination)
    end.max
  end

  def run_combination(input, combination)
    signal = 0
    combination.each do |phase|
      signal = run_amplifier_a(input, phase, signal)
    end
    signal
  end





  def calculate_b(input)
    # Generate all possible combinations
    combinations = [5, 6, 7, 8, 9].permutation.to_a.reverse

    combinations.map do |combination|
      run_combination_b(input.clone, combination)
    end.max
  end


  def run_combination_b(input, combination)
    signal = 0


    letters = %w{A B C D E}
    amplifiers = letters.each_with_index.map do |letter, index|
      amplifier = Intcode.new(memory: input.dup, name: "Amp #{letter}")
      amplifier.run
      amplifier.enter_input(combination[index])
      raise "ERROR WHEN PREPARING THE AMPLIFIER #{amplifier.name}" unless amplifier.status == 'waiting_for_input'
      amplifier
    end


    current_amplifier_pointer = 0
    iteration_counter = 0

    loop do
      # Find the amplifier
      amplifier = amplifiers[current_amplifier_pointer]
      # puts "Current amplifier is #{amplifier.name}"
      raise "MAX ITERATION REACHED" if iteration_counter > 100






      if amplifier.status == 'paused'
        amplifier.run
      end


      amplifier.enter_input(signal) if amplifier.status == 'waiting_for_input'
      signal = amplifier.output

      if amplifier.status == 'finished' && amplifier.name == 'Amp E'
        break
      end




      

      # Cycle through the amplifiers
      current_amplifier_pointer += 1
      if current_amplifier_pointer == 5
        current_amplifier_pointer = 0
      end
      iteration_counter += 1
    end

    return signal
  end













  def run_amplifier_a(input, phase, signal)
    runner = Intcode.new(memory: input)
    input_value = phase
    loop do
      runner.run
      if runner.status == 'waiting_for_input'
        runner.enter_input(input_value)
        input_value = signal
      elsif runner.status == 'finished'
        break
      end
    end
    return runner.output
  end
end

if !ARGV.include?('run')
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    include Something
    def test_calculate
      # Part A
      assert_equal(43_210, run_combination([3, 15, 3, 16, 1002, 16, 10, 16, 1, 16, 15, 15, 4, 15, 99, 0, 0], [4, 3, 2, 1, 0]))

      assert_equal(54321, run_combination([3,23,3,24,1002,24,10,24,1002,23,-1,23,
        101,5,23,23,1,24,23,23,4,23,99,0,0], [0,1,2,3,4]))
      assert_equal(65210, run_combination([3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
        1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0], [1,0,4,3,2]))

      assert_equal(43210, calculate([3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]))
      assert_equal(54321, calculate([3,23,3,24,1002,24,10,24,1002,23,-1,23,
        101,5,23,23,1,24,23,23,4,23,99,0,0]))
      assert_equal(65210, calculate([3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
          1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0]))



      # Part B
      assert_equal(139629729, run_combination_b([3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,
        27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5], [9,8,7,6,5]))

      assert_equal(139629729, calculate_b([3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,
        27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5]))



      assert_equal(18216, run_combination_b([3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,
        -5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,
        53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10], [9,7,8,5,6]))
    end
  end

else
  include Something

  puts calculate(File.read('07_input').split(',').map(&:to_i))
  puts calculate_b(File.read('07_input').split(',').map(&:to_i))
end
