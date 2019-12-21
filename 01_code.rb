#! /usr/bin/env ruby

module FuelCalculator
  def calculate(input)
    (input / 3).round(half: :down) - 2
  end

  def calculate_b(input)
    fuel = 0
    loop do
      input = calculate(input)
      break if input < 1
      fuel += input
    end

    return fuel
  end
end


if !ARGV.include?("run")
  require 'test/unit'

  class FuelCalculatorTest < Test::Unit::TestCase
    include FuelCalculator
    def test_calculate
      assert_equal(2, calculate(12))
      assert_equal(2, calculate(14))
      assert_equal(654, calculate(1969))
      assert_equal(33583, calculate(100756))
    end

    def test_calculate_b
      assert_equal(2, calculate_b(12))
      assert_equal(966, calculate_b(1969))
      assert_equal(50346, calculate_b(100756))
    end
  end
end

if ARGV.include?("run")
  include FuelCalculator

  result = 0
  File.readlines('01_input').each do |line|
    result += calculate_b(line.to_i)
  end
  
  puts result
end