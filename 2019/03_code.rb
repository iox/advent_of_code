#! /usr/bin/env ruby
# frozen_string_literal: true

module Something
  def calculate(wire1_instructions, wire2_instructions)
    wire1_positions = plot_path(wire1_instructions)
    wire2_positions = plot_path(wire2_instructions)

    intersections = wire1_positions & wire2_positions
    intersections.map { |i| i[0].abs + i[1].abs }.min
  end

  def calculate_b(wire1_instructions, wire2_instructions)
    wire1_positions = plot_path(wire1_instructions)
    wire2_positions = plot_path(wire2_instructions)

    intersections = wire1_positions & wire2_positions

    intersections.map do |i|
      count_steps(wire1_instructions, i) +
        count_steps(wire2_instructions, i)
    end.min
  end

  def count_steps(instructions, intersection)
    count = 0
    positions = []
    instructions.split(',').each do |instruction|
      direction = instruction[0]
      number = instruction[1..-1].to_i
      number.times do
        return count if intersection == positions.last

        last_x = positions.last ? positions.last[0] : 0
        last_y = positions.last ? positions.last[1] : 0
        if direction == 'R'
          positions.push([last_x + 1, last_y])
        elsif direction == 'L'
          positions.push([last_x - 1, last_y])
        elsif direction == 'U'
          positions.push([last_x, last_y + 1])
        elsif direction == 'D'
          positions.push([last_x, last_y - 1])
        end
        count += 1
      end
    end
    positions
  end

  def plot_path(instructions)
    positions = []
    instructions.split(',').each do |instruction|
      direction = instruction[0]
      number = instruction[1..-1].to_i
      number.times do
        last_x = positions.last ? positions.last[0] : 0
        last_y = positions.last ? positions.last[1] : 0
        if direction == 'R'
          positions.push([last_x + 1, last_y])
        elsif direction == 'L'
          positions.push([last_x - 1, last_y])
        elsif direction == 'U'
          positions.push([last_x, last_y + 1])
        elsif direction == 'D'
          positions.push([last_x, last_y - 1])
        end
      end
    end
    positions
  end
end

if !ARGV.include?('run')
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    include Something
    def test_calculate
      assert_equal(6, calculate('R8,U5,L5,D3', 'U7,R6,D4,L4'))
      assert_equal(159, calculate('R75,D30,R83,U83,L12,D49,R71,U7,L72', 'U62,R66,U55,R34,D71,R55,D58,R83'))
      assert_equal(135, calculate('R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51', 'U98,R91,D20,R16,D67,R40,U7,R15,U6,R7'))

      assert_equal(30, calculate_b('R8,U5,L5,D3', 'U7,R6,D4,L4'))
      assert_equal(610, calculate_b('R75,D30,R83,U83,L12,D49,R71,U7,L72', 'U62,R66,U55,R34,D71,R55,D58,R83'))
      assert_equal(410, calculate_b('R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51', 'U98,R91,D20,R16,D67,R40,U7,R15,U6,R7'))
    end
  end

else
  include Something

  # result = 0
  # File.readlines('02_input').each do |line|
  #   result += calculate(line.to_i)
  # end

  # puts result
  lines = File.readlines('03_input')
  puts calculate(lines[0], lines[1])

  puts calculate_b(lines[0], lines[1])
end
