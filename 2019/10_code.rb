#! /usr/bin/env ruby
# frozen_string_literal: true

module Something
  def calculate(input)
    positions = get_asteroid_positions(input)

    sorted = positions.sort_by do |position|
      get_number_in_sight(input: input, left: position[0], top: position[1])
    end

    max = sorted.last

    puts "max: #{max.inspect}"

    get_number_in_sight(input:input, left: max[0], top: max[1])
  end

  def calculate_b(input)

    laser = [11, 19]

    positions = get_asteroid_positions(input) - [11,19]

    asteroids_with_angles = positions.map do |position|
      {
        position: position,
        angle: get_angle(origin: laser, position: position)
      }
    end

    asteroids_with_angles.sort_by! do |asteroid|
      asteroid[:angle]
    end

    uniq_angles = asteroids_with_angles.map do |asteroid|
      asteroid[:angle]
    end.uniq.sort

    puts uniq_angles.inspect

    bet_asteroid = nil
    200.times.with_index do |index|
      bet_angle = uniq_angles[index]

      puts "Vaporizing #{bet_angle}"

      candidates = asteroids_with_angles.select do |asteroid|
        asteroid[:angle] == bet_angle
      end
  
      puts "  > candidates: #{candidates.inspect}"
  
      bet_asteroid = candidates.sample[:position]
    end

    

    #2401!!!





    (bet_asteroid[0] * 100) + bet_asteroid[1]
  end

  def get_number_in_sight(input:, left:, top:)
    positions = get_asteroid_positions(input)

    in_sight = 0
    angles = []


    positions.each do |position|
      next if position == [left, top] # I can not see myself

      angle = get_angle(origin: [left, top], position: position)
      next if angles.include?(angle)

      angles << angle
      in_sight += 1
    end

    in_sight
  end

  def get_angle(origin:, position:)
    relative_position = [position[1] - origin[1], position[0] - origin[0]]
    angle = (Math.atan2(relative_position[0], relative_position[1]) * 180 / Math::PI).round(1)
    angle = angle + 90

    if angle < 0
      angle = angle + 360#raise "WTF #{origin.inspect} #{position.inspect}"
    end

    angle
  end

  def get_asteroid_positions(input)
    positions = []
    input.split("\n").map(&:chomp).each_with_index do |line, y|
      line.chars.each_with_index do |char, x|
        if char == '#'
          positions << [x, y]
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
      example_easy = File.read('10_example_easy')

      assert_equal(0, get_angle(origin: [0,0], position: [0, -1]))
      assert_equal(90.0, get_angle(origin: [0,0], position: [1,0]))
      assert_equal(180.0, get_angle(origin: [0,0], position: [0,1]))
      assert_equal(270.0, get_angle(origin: [0,0], position: [-1, 0]))
      
      assert_equal(0, get_angle(origin: [1,0], position: [1, -1]))
      assert_equal(180.0, get_angle(origin: [1,0], position: [1, 1]))


      assert_equal(315.0, get_angle(origin: [1,1], position: [0, 0]))


      assert(get_asteroid_positions(example_easy).include?([1,0]))
      assert(get_asteroid_positions(example_easy).include?([4,0]))
      assert(get_asteroid_positions(example_easy).include?([4,4]))
      assert(!get_asteroid_positions(example_easy).include?([0,0]))
      assert_equal(10, get_asteroid_positions(example_easy).size)

      assert_equal(7, get_number_in_sight(input: example_easy, left: 1, top: 0))
      assert_equal(6, get_number_in_sight(input: example_easy, left: 0, top: 2))
      assert_equal(7, get_number_in_sight(input: example_easy, left: 4, top: 0))
      assert_equal(7, get_number_in_sight(input: example_easy, left: 4, top: 4))
      assert_equal(8, calculate(example_easy))

      example_a = File.read('10_example_a')
      assert_equal(33, get_number_in_sight(input: example_a, left: 5, top: 8))
      assert_equal(33, calculate(example_a))

      example_b = File.read('10_example_b')
      assert_equal(35, get_number_in_sight(input: example_b, left: 1, top: 2))
      assert_equal(35, calculate(example_b))

      example_c = File.read('10_example_c')
      assert_equal(41, get_number_in_sight(input: example_c, left: 6, top: 3))
      assert_equal(41, calculate(example_c))

      example_d = File.read('10_example_d')
      assert_equal(210, get_number_in_sight(input: example_d, left: 11, top: 13))
      assert_equal(210, calculate(example_d))
    end
  end

else
  include Something

  puts calculate(File.read('10_input'))
  puts calculate_b(File.read('10_input'))

end
