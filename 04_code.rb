#! /usr/bin/env ruby
# frozen_string_literal: true

module Something

  def calculate(input)
    ans1 = 0

    input.each do |x|
      chars = x.to_s.chars
      sorted = chars.sort
      next if chars != sorted

      slices = chars.slice_when { |a, b| a!= b }.to_a

      ans1 += 1 if slices.count < 6
    end

    ans1
  end

  def calculate_b(input)
    ans2 = 0

    input.each do |x|
      chars = x.to_s.chars
      sorted = chars.sort
      next if chars != sorted

      slices = chars.slice_when { |a, b| a!= b }.to_a

      ans2 += 1 if slices.any? { |x| x.size == 2 }
    end

    ans2
  end


end

if !ARGV.include?('run')
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    include Something
    def test_calculate
      assert_equal(true, part2("112233"))
      assert_equal(false, part2("123444"))
      assert_equal(false, part2("124444"))
      assert_equal(false, part2("123334"))
      assert_equal(false, part2("122234"))
      assert_equal(true, part2("111122"))
    end
  end

else
  include Something

  input = (245_182..790_572).to_a

  puts calculate(input)
  puts calculate_b(input)
  puts "------"
end



@answer1 = 0
@answer2 = 0

low = 245_182
high = 790_572

class Array
  def sorted?
    sort == self
  end

  def distinct?
    uniq != self
  end
end

(low..high).each do |i|
  digits = i.digits.reverse
  if digits.sorted? && digits.distinct?
    @answer1 += 1
    if digits.chunk(&:itself).any? { |a| a.last.size == 2 }
      @answer2 += 1
    end
  end
end

pp @answer1
pp @answer2



pp "-------"

a1 = 245_182
a2 = 790_572

ans1 = 0
ans2 = 0

total = (a1..a2).each do |x|
  chars = x.to_s.chars
  sorted = chars.sort
  next if chars != sorted

  slices = chars.slice_when { |a, b| a!= b }.to_a

  ans1 += 1 if slices.count < 6
  ans2 += 1 if slices.any? { |x| x.size == 2 }
end

puts ans1
puts ans2