def parser(input)
  input.split("\n").map(&:strip).map do |line|
    result = line.split(": ")[0].to_i
    numbers = line.split(": ")[1].split(" ").map(&:strip).map(&:to_i)
    [result, numbers]
  end
end

def part1(input)
  equations = parser(input)
  equations.map { |e| solve(e[0], 0, e[1]) }.reduce(:+)
end

# def part2(input)
#   equations = parser(input)
#   equations.map { |e| solve(e[0], 0, e[1], true) }.reduce(:+)
# end

# puts part1(File.read("2024/day8.txt"))
# puts part2(File.read("2024/day8.txt"))



require 'minitest/autorun'
require 'minitest/color'

class TestDay3 < Minitest::Test
  def sample
    <<-EOF
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    EOF
  end
  def test_part1
    parsed = parser(sample)
    assert_equal [190, [10,19]], parsed[0]
    assert_equal 3749, part1(sample)
  end

  # def test_part2
  #   assert_equal 11387, part2(sample)
  #   assert_equal 0, solve(parsed[3][0], 0, parsed[3][1], false)
  # end
end