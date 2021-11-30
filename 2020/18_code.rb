def part1(operation)
  2.times do
    operation.scan(/\(([\d\ +\*]*)\)/).each do |sub_operation|
      sub_result = stupid_summer(sub_operation[0])
      operation.gsub!("("+sub_operation[0]+")", sub_result.to_s)
    end
  end

  # puts operation
  stupid_summer(operation)
end






def stupid_summer(operation)
  sum = 0
  next_action = :sum
  operation.split(" ").each do |command|
    if command == "+"
      next_action = :sum
    elsif command == "*"
      next_action = :multiply
    else
      if next_action == :sum
        sum += command.to_i
      else
        sum *= command.to_i
      end
    end
  end
  sum
end








def part2(operation)
  # puts "start: #{operation}"
  5.times do
    # puts operation
    operation.scan(/\(([\d\ +\*]*)\)/).each do |sub_operation|
      # puts "    >>>> #{sub_operation[0]}"

      sub_result = precedence_chaos(sub_operation[0].dup)
      # puts "replacing (#{sub_operation[0]}) with #{sub_result}"
      operation.gsub!("("+sub_operation[0]+")", sub_result.to_s)
      # puts operation
    end
  end
  precedence_chaos(operation)
end


def precedence_chaos(operation)
  10.times do
    # puts operation
    sub_operation = operation.scan(/(\d+ \+ \d+)/).first
    if sub_operation
      sub_result = eval(sub_operation[0])
      # puts "      >>>>>  #{sub_operation[0]} with sub_result #{sub_result}"
      operation.gsub!(sub_operation[0], sub_result.to_s)
    end
  end
  # puts "About to eval #{operation}"
  eval(operation)
end





if ARGV.include?('test')
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    def test_part1
      assert_equal(51,      part1("1 + (2 * 3) + (4 * (5 + 6))"))
      assert_equal(71,      part1("1 + 2 * 3 + 4 * 5 + 6"))
      assert_equal(26,      part1("2 * 3 + (4 * 5)"))
      assert_equal(437,     part1("5 + (8 * 3 + 9 + 3 * 4 * 3)"))
      assert_equal(12240,   part1("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))"))
      assert_equal(13632,   part1("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"))
    end

    def test_part2
      assert_equal(231,     part2("1 + 2 * 3 + 4 * 5 + 6"))
      assert_equal(51,      part2("1 + (2 * 3) + (4 * (5 + 6))"))
      assert_equal(46,      part2("2 * 3 + (4 * 5)"))
      assert_equal(1445,    part2("5 + (8 * 3 + 9 + 3 * 4 * 3)"))
      assert_equal(669060,  part2("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))"))
      assert_equal(23340,   part2("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"))
    end
  end
end

sum = 0
File.read('18_input').split("\n").each do |line|
  sum += part1(line)
end
puts sum


sum = 0
File.read('18_input').split("\n").each do |line|
  sum += part2(line)
end
puts sum
















# Reddit stuff, used to find exactly where my code was failing :D


# class WeirdInt
#   attr_reader :value

#   def initialize value
#     @value = value
#   end

#   def + m
#     WeirdInt.new(@value * m.value)
#   end

#   def * m
#     WeirdInt.new(@value + m.value)
#   end
# end

# def part2_reddit(line)
#   # puts "reddit line #{line}"
#   line.gsub!(/(\d+)/) { "WeirdInt.new(#$1)" }
#   eval line.tr('+*', '*+')
# end




# sum = 0
# my_results = File.read('18_input').split("\n").map do |line|
#   part2(line)
# end
# reddit_results = File.read('18_input').split("\n").map do |line|
#   part2_reddit(line).value
# end

# my_results.each_with_index do |result, index|
#   if reddit_results[index] != result
#     raise "STOP HERE! >>>>   index #{index} SHOULD BE    >>>>    #{reddit_results[index]}    <<<<    BUT I GOT     #{result}"
#   end 
# end



#   puts "LINE IS #{line}"
#   if part2(line.clone) != part2_reddit(line.clone)
#     raise "STOP HERE! #{line}  >>>>   SHOULD BE    >>>>    #{part2_reddit(line)}    <<<<    BUT I GOT     #{part2(line)}"
#   end
#   puts "one sum worked!"
#   sum += part2(line)
# end
# puts sum



# Find code that works
# Go through each operation until I find the one where it's different




