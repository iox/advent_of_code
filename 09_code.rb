#! /usr/bin/env ruby

load 'intcode.rb'

module Something
  def calculate(input)
    runner = Intcode.new(memory: input)
    loop do
      if runner.status == 'waiting_for_input'
        runner.enter_input(1)
      elsif runner.status == 'finished'
        break
      else
        runner.run
      end

      puts runner.output
    end
    runner.output
  end


  def calculate_b(input)
    runner = Intcode.new(memory: input)
    loop do
      if runner.status == 'waiting_for_input'
        runner.enter_input(2)
      elsif runner.status == 'finished'
        break
      else
        runner.run
      end

      puts runner.output
    end
    runner.output
  end
end


if !ARGV.include?("run")
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    include Something
    def test_calculate
      assert_equal(16, calculate([1102,34915192,34915192,7,4,7,99,0]).digits.size)
      assert_equal(1125899906842624, calculate([104,1125899906842624,99]))
      assert_equal(99, calculate([109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]))
    end
  end

else
  include Something


  # puts calculate([109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99])
  puts calculate(File.read('09_input').split(',').map(&:to_i))
  puts calculate_b(File.read('09_input').split(',').map(&:to_i))
  
end
