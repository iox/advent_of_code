#! /usr/bin/env ruby
# frozen_string_literal: true

module Something
  def calculate(input)
    # 2 big mistakes while making this:
    # - Do not realise that the sorting could be different
    # - Do not realise that chomp is important with readlines
    direct_orbits = Hash.new

    direct_orbit_count = 0
    indirect_orbit_count = 0

    for line in input
      planet = line.split(')')[0]
      moon = line.split(')')[1]
      direct_orbits[moon] = planet
      direct_orbit_count += 1
    end

    for line in input
      planet = line.split(')')[0]
      while planet && planet != "COM"
        planet = direct_orbits[planet]
        indirect_orbit_count += 1
      end

    end

    direct_orbit_count + indirect_orbit_count
  end




  def calculate_b(input)
    direct_orbits = Hash.new
    for line in input
      planet = line.split(')')[0]
      moon = line.split(')')[1]
      direct_orbits[moon] = planet
    end


    ancestors_of_you = []
    planet = "YOU"
    while planet && planet != "COM"
      planet = direct_orbits[planet]
      ancestors_of_you << direct_orbits[planet]
    end


    ancestors_of_san = []
    planet = "SAN"
    while planet && planet != "COM"
      planet = direct_orbits[planet]
      ancestors_of_san << direct_orbits[planet]
    end


    # Find all ancestors of YOU
    puts "\n\n\n Ancestor of YOU: #{ancestors_of_you.size} \n\n\n"
    puts "\n\n\n Ancestor of SAN: #{ancestors_of_san.size} \n\n\n"

    different_ancestors = ancestors_of_you - ancestors_of_san

    puts "Different: #{different_ancestors.size}"

    
    # Find all ancestors of SAN

    # Find the closest common ancestor

    # Count steps







  end
end

if !ARGV.include?('run')
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    include Something
    def test_calculate
      assert_equal(1, calculate(
        ['COM)B']
      ))
      assert_equal(3, calculate(
        ['COM)B', 'B)C']
      ))
      assert_equal(5, calculate(
        ['COM)B', 'B)C', 'B)E']
      ))
      assert_equal(6, calculate(
        ['COM)B', 'B)C', 'C)E']
      ))
      assert_equal(6, calculate(
        ['B)C', 'C)E', 'COM)B']
      ))
      assert_equal(6, calculate(
        ['COM)B', 'B)C', 'C)D']
      ))
      assert_equal(10, calculate(
        ['COM)B', 'B)C', 'C)D', 'D)E']
      ))
      assert_equal(42, calculate(
                         ['COM)B', 'B)C', 'C)D', 'D)E', 'E)F', 'B)G',
                          'G)H',
                          'D)I',
                          'E)J',
                          'J)K',
                          'K)L']
                       ))
    end

    def test_calculate_b
      
      assert_equal(4, calculate_b(
                         ['COM)B',
                          'B)C',
                          'C)D',
                          'D)E',
                          'E)F',
                          'B)G',
                          'G)H',
                          'D)I',
                          'E)J',
                          'J)K',
                          'K)L',
                          'K)YOU',
                          'I)SAN']
                       ))
    end
    
  end

else
  include Something

  puts calculate(File.readlines('06_input').map(&:chomp))
  puts calculate_b(File.readlines('06_input').map(&:chomp))
end
