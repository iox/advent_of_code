# watch -c "ruby day3.rb"
# Press F5 to start debugger or "rdbg day3.rb"


def parser(input)
  input.split("\n").map(&:strip).map do |line|
    result = line.split(": ")[0].to_i
    numbers = line.split(": ")[1].split(" ").map(&:strip).map(&:to_i)
    [result, numbers]
  end
end

def solve(target, current, array, concat_allowed = false)
  if current > target
    0
  elsif array.empty?
    current == target ? target : 0
  else
    first = array.first
    rest = array[1..]
    sum_result = solve(target, current + first, rest, concat_allowed)
    mult_result = solve(target, current * first, rest, concat_allowed)
    return target if sum_result == target
    return target if mult_result == target

    if concat_allowed
      concat_result = solve(target, (current.to_s + first.to_s).to_i, rest, concat_allowed)
      return target if concat_result == target
    end
    return 0
  end
end


def part1(input)
  equations = parser(input)
  equations.map { |e| solve(e[0], 0, e[1]) }.reduce(:+)
end
  

def part2(input)
  equations = parser(input)
  equations.map { |e| solve(e[0], 0, e[1], true) }.reduce(:+)
end










puts part1(File.read("2024/day7.txt"))
puts part2(File.read("2024/day7.txt"))




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
    
    assert_equal 190, solve(parsed[0][0], 0, parsed[0][1])
    assert_equal 3267, solve(parsed[1][0], 0, parsed[1][1])
    assert_equal 0, solve(parsed[2][0], 0, parsed[2][1])
    assert_equal 292, solve(parsed[8][0], 0, parsed[8][1])

    assert_equal 3749, part1(sample)

    # Enabling concatenation
    assert_equal 0, solve(parsed[3][0], 0, parsed[3][1], false)
    assert_equal 156, solve(parsed[3][0], 0, parsed[3][1], true)
    assert_equal 7290, solve(parsed[4][0], 0, parsed[4][1], true)
    assert_equal 11387, part2(sample)
  end
end