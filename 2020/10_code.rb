def part1(adapters)

  builtin_joltage_adapter = adapters.max + 3

  current_joltage = 0
  one_jolt_adapters = []
  two_jolt_adapters = []
  three_jolt_adapters = []

  loop do
    if current_joltage == adapters.max
      three_jolt_adapters << builtin_joltage_adapter
      break
    end
    current_joltage += 1
    if adapters.include?(current_joltage)
      one_jolt_adapters << current_joltage
      next   
    end
    current_joltage += 1
    if adapters.include?(current_joltage)
      two_jolt_adapters << current_joltage
      next   
    end
    current_joltage += 1
    if adapters.include?(current_joltage)
      three_jolt_adapters << current_joltage
      next   
    end
  end

  [one_jolt_adapters.size, three_jolt_adapters.size]
end


def part2(data)
  valid_combinations = [nil,nil,nil,1]
  data.each do |adapter|
    valid_combinations[adapter+3] = valid_combinations[adapter..adapter+2].compact.sum
  end
  puts valid_combinations.inspect
  # [nil, nil, nil, 1, 1, 2, 4, nil, nil, 4, nil, nil, 4, 4, 8, 16, nil, nil, 16, 16, 32, .....]
  valid_combinations.last
end










def example_data
  [1, 4, 5, 6, 7, 10, 11, 12, 15, 16, 19]
end


def example_data2
  [1, 2, 3, 4, 7, 8, 9, 10, 11, 14, 17, 18, 19, 20, 23, 24, 25, 28, 31, 32, 33, 34, 35, 38, 39, 42, 45, 46, 47, 48, 49]
end







if ARGV.include?('test')
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    def test_part1
      assert_equal([7, 5], part1(example_data))
      assert_equal([22, 10], part1(example_data2))
    end

    def test_part2
      assert_equal(8, part2(example_data))
      assert_equal(19208, part2(example_data2))
    end
  end

else

  data = File.read('10_input').split("\n").map(&:to_i).sort
  puts "Part 1: #{part1(data).reduce(:*)}"
  puts "Part 2: #{part2(data)}"

end

























# def part2(adapters)

#   builtin_joltage_adapter = adapters.max + 3

#   current_joltage = 0
#   one_jolt_adapters = []
#   two_jolt_adapters = []
#   three_jolt_adapters = []


#   queue = []
#   queue << 1 if adapters.include?(1)
#   queue << 2 if adapters.include?(2)
#   queue << 3 if adapters.include?(3)
#   valid_combinations = 0

#   counter = 0

#   loop do

#     # if queue.size % 100000 == 0
#     #   puts "Queue.size #{queue.size}"
#     #   puts queue.last.inspect
#     #   puts "Valid combinations #{valid_combinations}"
#     # end

#     break if queue.empty?

#     last = queue.shift

#     if last == adapters.max
#       valid_combinations += 1
#       next
#     end


#     if adapters.include?(last + 1)
#       queue << last + 1
#     end

#     if adapters.include?(last + 2)
#       queue << last + 2
#     end

#     if adapters.include?(last + 3)
#       queue << last + 3
#     end
#   end

#   valid_combinations
# end











# def part2fast(adapters)
#   # I need to use combinations
#   # I need to use factorials: 5! => 5*4*3*2*1 => 5.downto(1).inject(:*)
  
#   # total = adapters.size

#   # a,b=part1(adapters)

#   # factorial(total) / (factorial(a+1)* factorial(b))


#   max_number = adapters.size
#   min_number = adapters.max / 3

#   (min_number..max_number).to_a



# end



# def count_me(parent_tree, number, valid_options)
#   elements = parent_tree[number]  # [14, 12]

#   for element in elements
#     count_me(parent_tree, element, valid_options)
#   end
# end
















# # 11 elements in the list
# # 7 one jolt jumps
# # 5 three jolt jumps
# # max: 19
# # expected result: 8


# def factorial(n)
#   n.downto(1).inject(:*)
# end


# # 31 elements in the list
# # 22 one jolt jumps
# # 10 three jolt jumps
# # max: 49
# # expected result: 19208



# def example_data_benchmark
#   [3, 6, 9, 10, 12, 14, 15]

#   #                            15
#   #                10 .. 12 >
#   #                            14 .. 15
#   # 3 .. 6 .. 9 >
#   #                            15
#   #                12 >
#   #                            14 .. 15




#   # 15 (1 valid option)
#   # If we find 2 parents, we multiply by 2
#   # Then we take each of the 2 parents, and we check how many ancestors we have
#   # And we multiply
#   # Until we reach 0



  
#   # 15 >
#   #           14 .. 12
#   #                    9 .. 6 .. 3
#   #                    10 .. 9 .. 6 .. 3
#   #           12 > 
#   #                9 .. 6 .. 3
#   #                10 .. 9 .. 6 .. 3

#   # Result: 4 valid possibilities

# end






# else

  # puts part2_b(example_data2).values
  # puts part2_b(example_data2).values.select{|v| v>0}.reduce(:*)

