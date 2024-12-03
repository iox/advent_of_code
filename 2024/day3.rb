# watch -c "ruby day3.rb"
# Press F5 to start debugger or "rdbg day3.rb"


def part1_parser(input)
  scanned = input.scan(/mul\(\d+,\d+\)/)
  mapped = scanned.map do |instruction|
    clean_instruction(instruction)
  end
  mapped
end

def clean_instruction(instruction)
  scanned_pair = instruction.scan(/\d+,\d+/)[0]
  scanned_pair.split(",").map(&:to_i)
end



def part1(input)
  result = part1_parser(input)
  result.map { |x,y| x*y }.reduce(:+)
end
  








def part2_scanner(input)
  input.scan(/mul\(\d+,\d+\)|don't\(\)|do\(\)/)
end

def part2_logic(instructions)
  valid = []
  enabled = true
  instructions.each do |instruction|
    if instruction.include?("mul") && enabled
      valid << clean_instruction(instruction)
    elsif instruction.include?("don't")
      enabled = false
    elsif instruction.include?("do")
      enabled = true
    end
  end
  valid
end


def part2(input)
  instructions = part2_scanner(input)
  valid_instructions = part2_logic(instructions)
  valid_instructions.map { |x,y| x*y }.reduce(:+)
end






puts part1(File.read("2024/day3.txt"))
puts part2(File.read("2024/day3.txt"))




require 'minitest/autorun'
require 'minitest/color'

class TestDay3 < Minitest::Test
  def test_part1

    sample = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
    
    assert_equal 4, part1_parser(sample).size
    assert_equal [2,4], part1_parser(sample)[0]
    assert_equal [5,5], part1_parser(sample)[1]
    assert_equal [11,8], part1_parser(sample)[2]
    assert_equal [8,5], part1_parser(sample)[3]

    assert_equal 161, part1(sample)


    sample3 = "mul(4*, mul(6,9!, ?(12,34)"
    assert_equal 0, part1_parser(sample3).size

    sample4 = "mul ( 2 , 4 )"
    assert_equal 0, part1_parser(sample4).size

    sample2 = "?select()@ )select()>,how()mul(627,742)<??$&@mul(556,721)- [mul(436,900)who()^][*mul(339,267)<mul(932,131),%?mul(946,538)-who()mul(120,296)~mul(470,838)]:#<how()mul(582,167)mul(89,630)/:--select()how(715,850)/>:)mul(472,964)"
    assert_equal 11, part1_parser(sample2).size
  end


  def test_part2
    sample = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
    # instructions = part2_scanner(sample)
    # assert_equal 6, instructions.size
    
    # valid_instructions = part2_logic(instructions)
    
    # assert_equal 2, valid_instructions.size

    assert_equal 48, part2(sample)
  end
end