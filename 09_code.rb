def part1(preamble:, data:)
  numbers = data.split("\n").map(&:to_i)

  numbers.each_with_index do |number, index|
    next if index < preamble
    
    previous_numbers = numbers[index - preamble, preamble]

    permutations = previous_numbers.permutation(2).to_a

    sums = permutations.map{|p| p[0] + p[1]}.uniq
    if !sums.include?(number)
      break number
    end
  end

end


def part2(preamble:, data:, target:)
  numbers = data.split("\n").map(&:to_i)

  numbers.each_with_index do |number, index|
    indexes = [index]
    counter = 0
    result = loop do
      counter += 1
      indexes << index + counter
      candidates = numbers.values_at(*indexes)
      sum = candidates.reduce(:+)
      if sum == target
        break candidates
      elsif sum > target
        break "NOPE"
      end
    end
    
    if result.is_a?(Array)
      break result
    end
  end

end




def example_data
<<-EXAMPLEINPUT
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
EXAMPLEINPUT
end



if ARGV.include?('test')
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    def test_part1
      assert_equal(127, part1(preamble: 5, data: example_data))
    end

    def test_part2
      assert_equal([15, 25, 47, 40], part2(target: 127, preamble: 5, data: example_data))
    end
  end

end



# part2(target: 127, preamble: 5, data: example_data)




data = File.read('09_input')
part1_result = part1(preamble: 25, data: data)
puts "Part 1: #{part1_result}"

part2_numbers = part2(preamble: 25, data: data, target: part1_result)
part2_result = part2_numbers.min + part2_numbers.max
puts "Part 2: #{part2_result}"

