#! /usr/bin/env ruby

load 'moon.rb'

module Something
  def calculate(input:, steps:, rjust: 2)
    output = []
    moons = input.map do |position|
      Moon.new(initial_position: position, rjust: rjust)
    end

    steps.times do |index|
      output << ""
      output << "After #{index} steps:"
      moons.each do |moon|
        output << moon.status
      end

      moons.combination(2).to_a.each do |moon_a, moon_b|
        moon_a.apply_gravity_x(other: moon_b, amount: 1)
        moon_b.apply_gravity_x(other: moon_a, amount: 1)

        moon_a.apply_gravity_y(other: moon_b, amount: 1)
        moon_b.apply_gravity_y(other: moon_a, amount: 1)

        moon_a.apply_gravity_z(other: moon_b, amount: 1)
        moon_b.apply_gravity_z(other: moon_a, amount: 1)
      end

      moons.each do |moon|
        moon.apply_velocity
      end
    end

    output << ""
    output << "After #{steps} steps:"
    moons.each do |moon|
      output << moon.status
    end
    
    {
      total_energy: moons.sum{|moon| moon.energy},
      output: output
    }
  end
end




def calculate_b(input:, rjust: 2)
  moons = input.map do |position|
    Moon.new(initial_position: position, rjust: rjust)
  end

  counterx = 0
  loop do
    moons.combination(2).to_a.each do |moon_a, moon_b|
      moon_a.apply_gravity_x(other: moon_b, amount: 1)
      moon_b.apply_gravity_x(other: moon_a, amount: 1)
    end
    moons.each(&:apply_velocity)
    counterx += 1
    break if moons.map(&:velx).uniq == [0]
  end
  puts "The x axis goes back to 0 every #{counterx} steps"


  counterz = 0
  loop do
    moons.combination(2).to_a.each do |moon_a, moon_b|
      moon_a.apply_gravity_z(other: moon_b, amount: 1)
      moon_b.apply_gravity_z(other: moon_a, amount: 1)
    end
    moons.each(&:apply_velocity)
    counterz += 1
    break if moons.map(&:velz).uniq == [0]
  end
  puts "The z axis goes back to 0 every #{counterz} steps"



  countery = 0
  loop do
    if countery % 1000000 == 0
      puts "Countery #{countery}"
    end
    moons.combination(2).to_a.each do |moon_a, moon_b|
      moon_a.apply_gravity_y(other: moon_b, amount: 1)
      moon_b.apply_gravity_y(other: moon_a, amount: 1)
    end
    moons.each(&:apply_velocity)
    countery += 1
    break if moons.map(&:vely).uniq == [0]
  end
  puts "The y axis goes back to 0 every #{countery} steps"

  [counterx, countery, counterz].reduce(1, :lcm) * 2
end


if !ARGV.include?("run")
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    include Something

    INPUT_SAMPLE_1 = [
      {x: -1, y: 0, z: 2},
      {x: 2, y: -10, z: -7},
      {x: 4, y: -8, z: 8},
      {x: 3, y: 5, z: -1}
    ]
    OUTPUT_SAMPLE_1 = File.readlines('12_output_sample_1')
    TOTAL_ENERGY_SAMPLE_1 = 179

    INPUT_SAMPLE_2 = [
      {x: -8, y: -10, z: 0},
      {x: 5, y: 5, z: 10},
      {x: 2, y: -7, z: 3},
      {x: 9, y: -8, z: -3}
    ]
    OUTPUT_SAMPLE_2 = File.readlines('12_output_sample_2')
    TOTAL_ENERGY_SAMPLE_2 = 1940

    REAL_INPUT = [
      {x: 6, y: 10, z: 10},
      {x: -9, y: 3, z: 17},
      {x: 9, y: -4, z: 14},
      {x: 4, y: 14, z: 4}
    ]

    # def test_calculate_sample_1
    #   result = calculate(input: INPUT_SAMPLE_1, steps: 10, rjust: 2)
    #   output_lines = result[:output]
    #   OUTPUT_SAMPLE_1.each_with_index do |line, index|
    #     #puts output_lines[index+1]
    #     assert(output_lines.include?(line.chomp), "#{line.chomp} could not be found in the output")
    #   end
    #   assert_equal(TOTAL_ENERGY_SAMPLE_1, result[:total_energy])
    # end

    # def test_calculate_sample_2
    #   result = calculate(input: INPUT_SAMPLE_2, steps: 100, rjust: 3)
    #   output_lines = result[:output]
    #   OUTPUT_SAMPLE_2.each_with_index do |line, index|
    #     assert(output_lines.include?(line.chomp), "#{line.chomp} could not be found in the output")
    #   end
    #   assert_equal(TOTAL_ENERGY_SAMPLE_2, result[:total_energy])
    # end


    def test_calculate_b_sample_1
      assert_equal(2772, calculate_b(input: INPUT_SAMPLE_1))
    end


    def test_calculate_b_sample_2
      assert_equal(4686774924, calculate_b(input: INPUT_SAMPLE_2))
    end

    
  end

else
  include Something

  input = [
    {x: 6, y: 10, z: 10},
    {x: -9, y: 3, z: 17},
    {x: 9, y: -4, z: 14},
    {x: 4, y: 14, z: 4}
  ]

  # puts calculate(input: input, steps: 1000, rjust: 3)[:total_energy]

  puts calculate_b(input: input, rjust: 3)
end
