# watch -c "rspec 13_code.rb --force-color"

examples = File.read('13_example').split("\n\n").map{|p| p.split("\n").map(&:chars)}
input = File.read('13_input').split("\n\n").map{|p| p.split("\n").map(&:chars)}


def part1(patterns)
  sum = 0
  patterns.each do |pattern|
    # Columns
    sum += pattern_calculator(pattern.transpose)

    # Rows
    sum += pattern_calculator(pattern) * 100
    
  end
  return sum
end


describe 'part1' do
  it 'calculates part 1' do
    expect(part1(examples)).to eq 405
  end
end





def pattern_calculator(pattern)
  last_column = nil
  pattern.each_with_index do |column, i|
    if last_column.nil?
      last_column = column 
      next
    end

    if column == last_column
      # puts "\n\nFOUND A DUPLICATE COLUMN at index #{i}, checking the rest"
      left_index = i-1
      right_index = i
      delta = 1
      loop do
        if (left_index-delta) < 0
          # puts "We have reached the left corner, this is a reflection!"
          return i
        end
        left_column = pattern[left_index-delta]

        right_column = pattern[right_index+delta]
        if right_column.nil?
          # puts "We have reached the right corner, stop!"
          return i
        end

        if left_column != right_column
          # puts "No reflection in here :S"
          break
        end
        delta += 1
      end
      # return i
    else
      last_column = column
    end
  end

  return 0


end





describe 'pattern_calculator' do
  it 'calculates the amount for each pattern' do
    # The first example has a vertical reflection line
    expect(pattern_calculator(examples[0].transpose)).to eq 5

    # The first example does not have a horizontal reflection line
    expect(pattern_calculator(examples[0])).to eq 0

    # The second example has a horizontal reflection line
    expect(pattern_calculator(examples[1])).to eq 4

    # The second example does not have a vertical reflection line
    expect(pattern_calculator(examples[1].transpose)).to eq 0
  end
end

puts part1(input)







# For part 2 I need to find 2 rows which are almost the same but not quite, so switching a single bit would make them the same

# I somehow need to calculate, for every subsequent row, the binary distance between them. And if it's one, try to check if the rest of the pattern is valid. What a big mess!

# This is even crazier. On every pattern, I have one bit that I am allowed to change.
# On every comparison, if it fails, I need to check if there is a one bit diff
# If there is, I need to rerun the logic using 2 possible patterns, as it's possible to switch 2 bits.


def one_char_difference(str1, str2)
  return false if str1.nil? || str2.nil?
  diff_count = 0
  str1.zip(str2).each do |char1, char2|
    diff_count += 1 if char1 != char2
    return false if diff_count > 1
  end
  diff_count == 1
end


def smudge_detector(pattern)
  last_column = nil
  
  pattern.each_with_index do |column, i|
    bit_change_available = true

    # puts "Iterating i: #{i}"
    if last_column.nil?
      last_column = column 
      next
    end

    left_index = i - 1 
    right_index = i

    loop do
      # puts "  loop left_index #{left_index}  // right_index #{right_index}"
      if (left_index) < 0
        if bit_change_available == false
          # puts "We have reached the left corner, this is a reflection!"
          return i
        else
          break
        end
      end
      left_column = pattern[left_index]

      right_column = pattern[right_index]
      if right_column.nil?
        if bit_change_available == false
          # puts "We have reached the right corner and the bit was changed, stop!"
          return i
        else
          break
        end
      end

      if one_char_difference(left_column, right_column) && bit_change_available
        left_column = right_column
        bit_change_available = false
      end
        
      if left_column != right_column
        # puts "No reflection in here :S"
        break
      end

      left_index -= 1
      right_index += 1
    end

    last_column = column
  end

  return 0

end






describe 'smudge_detector' do
  it 'calculates the amount after correcting a smudge' do
    # The first example does not have a vertical reflection line
    expect(smudge_detector(examples[0].transpose)).to eq 0

    # The first example has an horizontal reflection line
    expect(smudge_detector(examples[0])).to eq 3

    # The second example does not have a vertical reflection line
    expect(smudge_detector(examples[1].transpose)).to eq 0

    # The second example has have an horizontal reflection line
    expect(smudge_detector(examples[1])).to eq 1
  end
end





def part2(patterns)
  sum = 0
  # puts "There are #{patterns.size} patterns"
  patterns.each_with_index do |pattern, i|
    # Columns
    column_result = smudge_detector(pattern.transpose)
    # puts "Pattern #{i+1}, found a vertical line in index #{column_result}" if column_result > 0
    sum += column_result

    # Rows
    row_result = smudge_detector(pattern) * 100
    # puts "Pattern #{i+1}, found an horizontal line in index #{row_result}" if row_result > 0
    sum += row_result
  end
  return sum
end


describe 'part2' do
  it 'calculates part 2' do
    expect(part2(examples)).to eq 400
  end
end

# puts "horizontal #{smudge_detector(input[4])}"
# puts "vertical result #{smudge_detector(input[4].transpose)}"
puts part2(input)

