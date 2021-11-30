def example_data
<<-EXAMPLE
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
EXAMPLE
end

def example_data2
<<-EXAMPLE
mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1
EXAMPLE
end


def part1(data)
  mem = Hash.new
  mask = nil

  data.split("\n").each do |instruction|
    if instruction.include?("mask")
      mask = instruction.split("mask = ")[1]
    end

    if instruction.include?("mem")
      address, value = parse_mem(instruction)
      corrected_value = apply_mask(mask, value)
      mem[address] = corrected_value
    end
  end

  mem.values.sum
end



def part2(data)
  mem = Hash.new
  mask = nil

  data.split("\n").each do |instruction|
    if instruction.include?("mask")
      mask = instruction.split("mask = ")[1]
    end

    if instruction.include?("mem")
      address, value = parse_mem(instruction)
      apply_floating_mask(mem, address, value, mask)
    end
  end

  mem.values.sum
end



def parse_mem(instruction)
  address = instruction.split("[")[1].split("]")[0].to_i
  value = instruction.split(" = ")[1].to_i
  
  return [address, value]
end

def apply_mask(mask, value)
  binary_value = value.to_s(2).rjust(36, "0")
  mask.chars.each_with_index do |char, index|
    if char == "1" || char == "0"
      binary_value[index] = char
    end
  end  

  binary_value.to_i(2)
end


def apply_floating_mask(mem, address, value, mask)
  binary_address = address.to_s(2).rjust(36, "0")
  floating_indexes = []

  mask.chars.each_with_index do |char, index|
    if char == "1"
      binary_address[index] = char
    end
    if char == "X"
      floating_indexes << index
    end
  end

  ["0","1"].repeated_permutation(floating_indexes.size).to_a.each do |permutation|
    new_address = binary_address.dup
    floating_indexes.each_with_index do |floating_index, index|
      new_address[floating_index] = permutation[index]
    end
    mem[new_address] = value
  end

end




if ARGV.include?('test')
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    def test_apply_mask
      assert_equal(73, apply_mask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X", 11))
      assert_equal(101, apply_mask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X", 101))
      assert_equal(64, apply_mask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X", 0))
    end

    def test_part1
      assert_equal(165, part1(example_data))
    end


  end
end


data = File.read('14_input')

# puts "Part 1 #{part1(data)}"


puts part2(example_data2)
puts part2(data)