def part1(input)
  stones = blink(input, 25)
  stones.values.sum
end

def part2(input)
  stones = blink(input, 75)
  stones.values.sum
end

def blink(input, iterations)
  stones = input.strip.split(" ").map(&:to_i)

  stones_hash = Hash.new(0)
  stones.each do |stone|
    stones_hash[stone] += 1
  end

  iterations.times do |i|
    new_stones_hash = Hash.new(0)
    stones_hash.each do |stone, count|
      if stone == 0
        new_stones_hash[1] += count
        next
      end

      if stone.to_s.length.even?
        midpoint = stone.to_s.length / 2
        new_stones_hash[stone.to_s[0...midpoint].to_i] += count
        new_stones_hash[stone.to_s[midpoint..-1].to_i] += count
        next
      end

      new_stones_hash[stone * 2024] += count
    end
    stones_hash = new_stones_hash
  end

  stones_hash
end

puts part1(File.read("day11.txt"))
puts part2(File.read("day11.txt"))



require 'minitest/autorun'
require 'minitest/color'

class TestDay3 < Minitest::Test
  def test_part1
    result_a = blink("0 1 10 99 999", 1) #[1, 2024, 1, 0, 9, 9, 2021976],
    assert_equal 2, result_a[1]
    assert_equal 1, result_a[2024]
    assert_equal 2, result_a[9]
    assert_equal 1, result_a[2021976]
    assert_equal 1, result_a[0]


    result_b = blink("125 17", 1)
    assert_equal 1, result_b[253000]
    
    
    result_c = blink("125 17", 5)
    assert_equal 2, result_c[4048]
    assert_equal 1, result_c[1036288]
    assert_equal 1, result_c[67]

    assert_equal 55312, part1("125 17")
  end
end