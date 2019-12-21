#! /usr/bin/env ruby

module Something
  def calculate(input)
    input * 2
  end
end


if !ARGV.include?("run")
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    include Something
    def test_calculate
      assert_equal(2, calculate(12))
    end
  end

else
  include Something

  result = 0
  File.readlines('02_input').each do |line|
    result += calculate(line.to_i)
  end
  
  puts result
end
