# TODO: My solution does not work because
# I have been working with strings, which does not really work
# First step: find a better data structure to represent the data I'm working with
# Sample: [123, 123, nil, nil, 123, 123, 124, nil, nil, 125]
# Each element represents either a block taken by a file or a space
# I think this can work

# Second step: pass this data structure to the compact method
# Third step: use this data structure to calculate the checksum


def decompress(input)
  # puts "DECOMPRESS: Input size: #{input.size}"
  current = :file
  id = 0
  text_result = ""
  array_result = []

  input.chars.each do |c|
    length = c.to_i

    length.times do 
      case current
      when :file
        # My problem: I don't know how to work with ids bigger than 9
        text_result += id.to_s
        array_result << id
      when :space
        text_result += "."
        array_result << nil
      end
    end

    case current
    when :file
      current = :space
      id += 1
    when :space
      current = :file
    end
  end

  return text_result, array_result
end



def compact_text(input)
  chars = input.chars
  # puts "COMPACT: Array size: #{chars.size}"
  iterations = 0
  loop do
    iterations += 1
    # puts "Iteration: #{iterations}" if iterations % 1000 == 0
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


def compact_array(input)
  iterations = 0
  loop do
    iterations += 1
    # puts "Iteration: #{iterations}" if iterations % 1000 == 0

    first_empty_slot = input.index(nil)
    break if first_empty_slot == nil

    last_element = input.pop

    if last_element == nil
      next
    end

    input[first_empty_slot] = last_element
  end

  input
end




def compact_array_part2(input)
  index_from_back = input.size - 1
  # puts "Input size: #{input.size}"
  loop do
    # puts "Index from back: #{index_from_back}" if index_from_back % 1000 == 0
    # Stop when we reach the start of the input
    break if index_from_back == -1

    # Skip empty spaces
    current_value = input[index_from_back]
    if current_value == nil
      index_from_back -= 1
      next
    end

    # Find the current file (starting from the back)
    current_file = [current_value]
    index_from_back -= 1

    # Load the complete file into current_file
    while input[index_from_back] == current_value
      current_file << current_value
      index_from_back -= 1
    end

    # Go through the input and find enough empty spaces
    empty_spaces = 0
    first_nil_position = 0
    input.drop(first_nil_position).each_with_index do |e, i|
      break if i > index_from_back
      if e == nil
        first_nil_position = i
        empty_spaces += 1
        if empty_spaces == current_file.size
          input[i - empty_spaces + 1..i] = current_file
          input[index_from_back + 1..index_from_back + current_file.size] = [nil] * current_file.size
          break
        end
      else
        empty_spaces = 0
      end
    end
  end


  return input

end


def part2(input)
  checksum = 0

  decompressed_text, decompressed_array = decompress(input)

  compacted = compact_array_part2(decompressed_array)

  compacted.each_with_index do |file, i|
    checksum += file.to_i * i
  end

  checksum
end



def part1(input)
  checksum = 0

  decompressed_text, decompressed_array = decompress(input)

  compacted = compact_array(decompressed_array)

  compacted.each_with_index do |file, i|
    checksum += file.to_i * i
  end

  # puts "Checksum: #{checksum}"

  checksum
end

puts part1(File.read("day9.txt").strip)
# puts part2(File.read("day9.txt"))



require 'minitest/autorun'
require 'minitest/color'

class TestDay3 < Minitest::Test
  def sample
    "2333133121414131402"
  end
  def test_part1
    assert_equal "0..111....22222", decompress("12345")[0]
    assert_equal [0,nil,nil,1,1,1,nil,nil,nil,nil,2,2,2,2,2], decompress("12345")[1]
    assert_equal "022111222", compact_text(decompress("12345")[0])
    assert_equal [0,2,2,1,1,1,2,2,2], compact_array(decompress("12345")[1])

    assert_equal "00...111...2...333.44.5555.6666.777.888899", decompress(sample)[0]
    assert_equal "0099811188827773336446555566", compact_text(decompress(sample)[0])
    assert_equal 1928, part1(sample)
  end

  def test_part2
    assert_equal [0,0,9,9,2,1,1,1,7,7,7,nil,4,4,nil,3,3,3,nil,nil,nil,nil,5,5,5,5,nil,6,6,6,6,nil,nil,nil,nil,nil,8,8,8,8,nil,nil], compact_array_part2(decompress(sample)[1])
    
    assert_equal 25, part2("11133")
    assert_equal 2858, part2(sample)
  end
end