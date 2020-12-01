#! /usr/bin/env ruby

load 'moon.rb'

module Something
  def calculate(input:, phases:)
    base_pattern = [0, 1, 0, -1]

    phases.times do |number|
      chars = input.chars
      chars = chars.map.with_index do |char, index|
        line_result = chars.map.with_index do |char_b, index_b|
          pattern = base_pattern.flat_map { |el| [el] * (index + 1) }
          pattern.drop(1)
          pattern_index = (index_b + 1) % pattern.size          
          pattern_value = pattern[pattern_index]
          result = (char_b.to_i * pattern_value)
          result
        end.sum
        line_result = line_result.to_s.chars.last.to_i
        line_result
      end
      input = chars.join
    end

    return input
  end

  def calculate_b(input:, phases:)
    

    # partial, offset = input.chars.map(&:to_i), input[0, 7].to_i
    # puts "partial #{partial.inspect}"
    # puts "offset: #{offset.inspect}"
    # full = (partial * 10_000)[offset..-1]

    # puts "full.size #{full.size}"

    # 100.times do
    #   (full.size - 2).downto(0) do |i|
    #     full[i] = (full[i] + full[i + 1]) % 10
    #   end
    # end
    # full.first(8).join


    start_position = input[0,7].to_i
    complete_input = input*10000
    last_half = complete_input[start_position..-1].chars.map(&:to_i)

    puts "complete_input.size #{complete_input.size}"
    puts "last_half.size #{last_half.size}"

    phases.times do |number|
      puts "PHASE #{number}"

      # last_half.each_with_index do |digit, index|
      (last_half.size - 2).downto(0) do |i|
        last_half[i] = (last_half[i] + last_half[i + 1]) % 10
      end

      # chars = chars.map.with_index do |char, index|
      #   line_result = chars.map.with_index do |char_b, index_b|
      #     pattern = base_pattern.flat_map { |el| [el] * (index + start_position.to_i + 1) }
      #     pattern.drop(1)
      #     pattern_index = (index_b + start_position.to_i + 1) % pattern.size          
      #     pattern_value = pattern[pattern_index]
      #     result = (char_b.to_i * pattern_value)
      #     result
      #   end.sum
      #   line_result = line_result.to_s.chars.last.to_i
      #   line_result
      # end
    end

    return last_half.first(8).join
  end


   
end






if !ARGV.include?("run")
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    include Something

    # def test_calculate
    #   assert_equal(calculate(input: "12345678", phases: 1), "48226158")
    #   assert_equal(calculate(input: "12345678", phases: 2), "34040438")
    #   assert_equal(calculate(input: "12345678", phases: 3), "03415518")
    #   assert_equal(calculate(input: "12345678", phases: 4), "01029498")
    #   assert_equal(calculate(input: "80871224585914546619083218645595", phases: 100)[0,8], "24176176")
    #   assert_equal(calculate(input: "19617804207202209144916044189917", phases: 100)[0,8], "73745418")
    #   assert_equal(calculate(input: "69317163492948606335995924319873", phases: 100)[0,8], "52432133")
    # end


    def test_calculate_b
      assert_equal(calculate_b(input: "03036732577212944063491565474664", phases: 100), "84462026")
      # assert_equal(calculate_b(input: "02935109699940807407585447034323", phases: 100), "78725270")
      # assert_equal(calculate_b(input: "03081770884921959731165446850517", phases: 100), "53553731")
    end
  end

else
  include Something

  # puts calculate(input: File.read('16_input'), phases: 100)
  puts calculate_b(input: File.read('16_input').chomp, phases: 100)
end
