#! /usr/bin/env ruby
# frozen_string_literal: true

load 'intcode.rb'

module Something
  def calculate(input)
    runner = Intcode.new(memory: input)
    loop do
      runner.run
      if runner.status == 'waiting_for_input'
        runner.enter_input(1) # the ID for the ship's air conditioner unit.
      elsif runner.status == 'paused'
        puts "The runner took a small pause with the output #{runner.output}"
      elsif runner.status == 'finished'
        puts "RUNNER HAS FINISHED!"
        break
      end
    end

    return runner.output
  end


  def calculate_b(input)
    runner = Intcode.new(memory: input)
    loop do
      runner.run
      if runner.status == 'waiting_for_input'
        runner.enter_input(5) # the ID for the ship's thermal radiator controller
      elsif runner.status == 'paused'
        puts "The runner took a small pause with the output #{runner.output}"
      elsif runner.status == 'finished'
        puts "RUNNER HAS FINISHED!"
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

    puts "SORRY; NO TESTS IN THIS FILE"
  end

else
  include Something

  input = File.read('05_input').split(',').map(&:to_i)
  puts calculate(input)

  input_b = File.read('05_input').split(',').map(&:to_i)
  puts calculate_b(input_b)

end
