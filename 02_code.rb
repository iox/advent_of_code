#! /usr/bin/env ruby
require 'timeout'

module Something
  def calculate(input)
    iterations = 0
    pointer = 0
    loop do
      iterations += 1
      if iterations > 10000
        return input
      elsif input[pointer] == 1
        input[input[pointer + 3]] = input[input[pointer + 1]] + input[input[pointer + 2]]
        pointer += 4
      elsif input[pointer] == 2
        input[input[pointer + 3]] = input[input[pointer + 1]] * input[input[pointer + 2]]
        pointer += 4
      elsif input[pointer] == 99
        break
      end
      if pointer > input.size
        pointer -= pointer.size
      end
    end

    return input
  end
end


if !ARGV.include?("run")
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    include Something
    def test_calculate
      # assert_equal([1,9,10,70,2,3,11,0,99,30,40,50], calculate_first_step([1,9,10,3,2,3,11,0,99,30,40,50]))
      assert_equal([3500,9,10,70,2,3,11,0,99,30,40,50], calculate([1,9,10,3,2,3,11,0,99,30,40,50]))
      assert_equal([2,0,0,0,99], calculate([1,0,0,0,99]))
      assert_equal([2,3,0,6,99], calculate([2,3,0,3,99]))
      assert_equal([2,4,4,5,99,9801], calculate([2,4,4,5,99,0]))
      assert_equal([30,1,1,4,2,5,6,0,99], calculate([1,1,1,4,99,5,6,0,99]))
    end
  end

else
  include Something


  # puts File.read('02_input')
  input = File.read('02_input').split(",").map(&:to_i)
  # puts input.class
  input[1] = 12
  input[2] = 2
  
  # puts calculate(input)




  counter = 0
  for noun in (0..99).to_a
    for verb in (0..99).to_a
      counter += 1
      test_input = input.dup
      test_input[1] = noun
      test_input[2] = verb
      # puts "test ##{counter} #{noun} #{verb}"
      if calculate(test_input)[0] == 19690720
        puts "FOUND: #{noun} #{verb}"
        puts ((100 * noun) + verb)
      end
    end
  end
end
