# TODO: My solution does not work because
# I have been working with strings, which does not really work
# First step: find a better data structure to represent the data I'm working with
# Sample: [123, 123, nil, nil, 123, 123, 124, nil, nil, 125]
# Each element represents either a block taken by a file or a space
# I think this can work

# Second step: pass this data structure to the compact method
# Third step: use this data structure to calculate the checksum


def decompress(input)
  puts "DECOMPRESS: Input size: #{input.size}"
  files = []
  current = :file
  id = 0
  result = ""

  input.chars.each do |c|
    length = c.to_i

    length.times do 
      case current
      when :file
        # My problem: I don't know how to work with ids bigger than 9
        result += id.to_s
      when :space
        result += "."
      end
    end

    case current
    when :file
      files << {id: id, length: length}
      current = :space
      id += 1
    when :space
      current = :file
    end
  end

  return result, files
end



def compact(input)
  chars = input.chars
  puts "COMPACT: Array size: #{chars.size}"
  iterations = 0
  loop do
    iterations += 1
    puts "Iteration: #{iterations}" if iterations % 1000 == 0
    first_empty_space = chars.index(".")
    break if first_empty_space == nil

    last_character = chars.pop

    if last_character == "."
      next
    end

    chars[first_empty_space] = last_character
  end

  chars.join
end








def part1(input)
  checksum = 0

  decompressed, files = decompress(input)
  puts "Decompressed: #{decompressed}"

  compacted = compact(decompressed)
  puts "Compacted: #{compacted}"

  compacted.chars.each_with_index do |file, i|
    checksum += file.to_i * i
  end

  puts "Checksum: #{checksum}"

  checksum
end

# def part2(input)
#   equations = parser(input)
#   equations.map { |e| solve(e[0], 0, e[1], true) }.reduce(:+)
# end

puts part1(File.read("day9.txt").strip)
# puts part2(File.read("2024/day8.txt"))



require 'minitest/autorun'
require 'minitest/color'

class TestDay3 < Minitest::Test
  def sample
    "2333133121414131402"
  end
  def test_part1
    assert_equal "0..111....22222", decompress("12345")[0]
    assert_equal ({id: 0, length: 1}), decompress("12345")[1][0]
    assert_equal ({id: 1, length: 3}), decompress("12345")[1][1]
    assert_equal ({id: 2, length: 5}), decompress("12345")[1][2]
    assert_equal "022111222", compact(decompress("12345")[0])

    assert_equal "00...111...2...333.44.5555.6666.777.888899", decompress(sample)[0]
    assert_equal "0099811188827773336446555566", compact(decompress(sample)[0])
    assert_equal 1928, part1(sample)
  end

  # def test_part2
  #   assert_equal 11387, part2(sample)
  #   assert_equal 0, solve(parsed[3][0], 0, parsed[3][1], false)
  # end
end