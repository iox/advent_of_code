def keypad(sequence, kind=:numeric)
  numeric_keypad = {
    '7' => [0, 0], '8' => [0, 1], '9' => [0, 2],
    '4' => [1, 0], '5' => [1, 1], '6' => [1, 2],
    '1' => [2, 0], '2' => [2, 1], '3' => [2, 2],    
                   '0' => [3, 1], 'A' => [3, 2]
  }
  directional_keypad = {
                   '^' => [0, 1], 'A' => [0, 2],
    '<' => [1, 0], 'v' => [1, 1], '>' => [1, 2]
  }

#     +---+---+
#     | ^ | A |
# +---+---+---+
# | < | v | > |
# +---+---+---+

# +---+---+---+
# | 7 | 8 | 9 |
# +---+---+---+
# | 4 | 5 | 6 |
# +---+---+---+
# | 1 | 2 | 3 |
# +---+---+---+
#     | 0 | A |
#     +---+---+


# The code is pretty cool, in the sense that it computes all possible paths


  keypad = kind == :numeric ? numeric_keypad : directional_keypad

  current_position = keypad['A'].dup
  results = [""]

  sequence.chars.map do |button|
    # puts "\nProcessing button: #{button} from sequence #{sequence}. Current position is #{keypad.invert[current_position]} (#{current_position.inspect})"
    target_position = keypad[button]

    diff_x = target_position[1] - current_position[1]
    diff_y = target_position[0] - current_position[0]

    directions = []

    if diff_x < 0
      directions << :left
    elsif diff_x > 0
      directions << :right
    end
    if diff_y < 0
      directions << :up
    elsif diff_y > 0
      directions << :down
    end

    next_position = nil
    possible_paths = directions.permutation.map do |dirs|
      my_pos = current_position.clone
      result = ""
      invalid = false
      dirs.each do |dir|
        if dir == :up
          diff_y.abs.times do
            my_pos[0] -= 1
            result += "^"
          end
        elsif dir == :down
          diff_y.abs.times do
            my_pos[0] += 1
            result += "v"
          end
        elsif dir == :left
          diff_x.abs.times do
            my_pos[1] -= 1
            result += "<"
          end
        elsif dir == :right
          diff_x.abs.times do
            my_pos[1] += 1
            result += ">"
          end
        end
        if !keypad.values.include?(my_pos)
          invalid = true 
          # puts "  INVALID: #{result} because my_pos is #{my_pos.inspect} (#{keypad.invert[my_pos]})"
        end
      end

      if invalid
        nil
      else
        # puts "  VALID: #{result} arrived at #{my_pos.inspect} (#{keypad.invert[my_pos]})"
        next_position = my_pos
        result
      end
    end.compact
    current_position = next_position

    new_results = []
    results.each do |result|
      possible_paths.each do |path|
        new_results << result + path + "A"
      end
    end

    results = new_results
  end

  results
end


def complexity(input)
  results_a = keypad(input)
  # puts "results_a: #{results_a.inspect}"
  results_b = results_a.map{|r| keypad(r, :directional_odd)}.flatten
  # results_b.map(&:size).min
  # puts "results_b: #{results_b.inspect}"
  results_c = results_b.map{|r| keypad(r, :directional_odd)}.flatten

  minimal_result =  results_c.sort_by(&:size).first
  minimal_size = minimal_result.size
  maximal_size = results_c.map(&:size).max
  puts "Slow logic: The number for #{input} is #{minimal_size} / maximal size is #{maximal_size}"
  puts minimal_result

  minimal_size * input.to_i

end


def complexity_part2(input)
  # results = keypad(input)
  # puts "\n\nProcessing #{input}"
  # 2.times do |i|
  #   # results = [results.sort_by(&:size).first]
  #   # puts "results: #{results.inspect}"
  #   results = results.map{|r| keypad(r, :directional_odd)}.flatten
  #   puts "  results.size: #{results.size}"

  # end
  # results.map(&:size).min * input.to_i


  # # We prepare a memory of the optimal conversions of single presses
  # memory = {
  #   ">>A" => ["<vvA", "vvA", "A"]
  # }

  # # If we don't have a memory, then we do it the slow way and we get the smallest solution and we put it to memory


  # # Once the memory is full, we initialize a counter hash:
  # counter = {
  #   ">>A" => 1,
  #   "<<A" => 2
  # }
  

  puts "\n"
  results_a = keypad(input)
  sorted_results = results_a.sort_by do |result|
    results_b = keypad(result, :directional_odd)
    results_c = results_b.map{|r| keypad(r, :directional_odd)}.flatten
    # puts "results_c #{results_c}"
    sizes = results_c.map(&:size)
    # puts "Sizes for #{result}. #{sizes.count} count with uniq values  #{sizes.uniq}"
    sizes.sort.first
  end
  smallest_result = sorted_results.first
  # puts "Selected the smallest result #{smallest_result}\n\n"

  # puts "smallest_result before split #{smallest_result}"
  new_keys = smallest_result.scan(/[^A]*A?/)
  new_keys.reject!(&:empty?)

  # puts "new_keys: #{new_keys}"
  counter = Hash.new(0)
  new_keys.each do |nkey|
    counter[nkey] += 1
  end


  memory = {"A" => ["A"]}
  4.times do
    new_counter = Hash.new(0)
    counter.each do |key, value|
      if memory[key].nil?
        # If the memory is empty, we run it and fill the memory
        results_a = keypad(key, kind: :directional_odd)
        
        sorted_results = results_a.sort_by do |result|
          results_b = keypad(result, :directional_odd)
          results_c = results_b.map{|r| keypad(r, :directional_odd)}.flatten
          # puts "results_c #{results_c}"
          sizes = results_c.map(&:size)
          # puts "Sizes for #{result} are #{sizes.uniq}"
          sizes.sort.first
        end
        smallest_result = sorted_results.first
        
        new_keys = smallest_result.scan(/[^A]*A?/)
        new_keys.reject!(&:empty?)
        # puts "new_keys for #{key}: #{new_keys}"
        memory[key] = new_keys
      end

      memory[key].each do |mkey|
        new_counter[mkey] += value
      end
    end
    counter = new_counter
  end

  sum = 0
  counter.each do |key, value|
    sum += key.size * value
  end

  puts "Fast logic: The number for #{input} is #{sum}"

  sum * input.to_i
end



































def part1(input)
  total = 0
  input.split("\n").each do |line|
    total += complexity(line.strip)
  end
  total
end

def part2(input)
  total = 0
  input.split("\n").each do |line|
    total += complexity_part2(line.strip)
  end
  total
end


puts part1(File.read("day21debug.txt"))

puts part2(File.read("day21debug.txt"))






# require 'minitest/autorun'
# require 'minitest/color'

# def sample
#   <<-EOF
#   029A
#   980A
#   179A
#   456A
#   379A
#   EOF
# end


# class TestDay3 < Minitest::Test
#   def test_part1
#     assert_equal keypad("A"), ["A"]
#     assert_includes keypad("9A"), "^^^AvvvA"
#     # assert_equal "^<A>vA", keypad("2A")
#     assert_equal 38*2, complexity("2A")


# #     assert_equal "<A^A^^>AvvvA", keypad("029A")
# #     assert_equal "v<<A^>>A", keypad("<A", :directional)
# #     assert_equal "v<<A^>>A<A>A<AAv>A^Av<AAA^>A", keypad("<A^A^^>AvvvA", :directional)

#     assert_equal 68*29, complexity("029A")
#     assert_equal 60*980, complexity("980A")
#     assert_equal 68*179, complexity("179A")
#     assert_equal 64*456, complexity("456A")
#     assert_equal 64*379, complexity("379A") # Bug: we are doing 4 steps extra that we don't need to do

#     assert_equal 126384, part1(sample)
#   end



# #   # def test_part2
# #   #   assert_equal 11387, part2(sample)
# #   #   assert_equal 0, solve(parsed[3][0], 0, parsed[3][1], false)
# #   # end
# end