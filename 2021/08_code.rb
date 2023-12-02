lines = File.readlines('08_input')

# digit_length_map = {
#   #0 => ['aaaa', 'bb', 'cc', 'ee', 'ff', 'gggg'],
#   2 => 1,
#   4 => 4,
#   3 => 7,
#   7 => 8
# }


# digit_length_map = {
#   #0 => ['aaaa', 'bb', 'cc', 'ee', 'ff', 'gggg'],
#   2 => [1],
#   3 => [7],
#   4 => [4],
#   5 => [3,5],
#   6 => [0,2,6,9],
#   7 => [8],
# }

# count = 0
# lines.each do |line|
#   output_values = line.split(" | ")[1].split(' ')
#   output_values.each do |output_value|
#     if digit_length_map[output_value.size] != nil
#       count += 1
#     end
#   end
# end

# puts count


# line = "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
# line = "bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef"
total = 0

lines.each do |line|

  signal_patterns = line.split(" | ")[0].split(' ')
  output_values = line.split(" | ")[1].split(' ')


  # Find the letters for number 1, 7 and 4
  letters_for_number_1 = signal_patterns.find{|sp| sp.size == 2}.chars
  letters_for_number_7 = signal_patterns.find{|sp| sp.size == 3}.chars
  letters_for_number_4 = signal_patterns.find{|sp| sp.size == 4}.chars

  # Find which letter is not part of numbers 1 and 4, that will be top position
  top_position = letters_for_number_7.find{|l| !letters_for_number_1.include?(l) && ! letters_for_number_4.include?(l)}
  puts "top_position: #{top_position}"

  # Find the candidates for the right column
  right_column_candidates = letters_for_number_7 - [top_position]
  puts "right_column_candidates: #{right_column_candidates}"

  # Find the signal corresponding to number 3. It's the only 5 letter signal including the whole right column
  letters_for_number_3 = signal_patterns.find do |sp|
    sp.size == 5 && right_column_candidates.all?{|c| sp.include?(c)}
  end.chars
  puts "letters_for_number_3: #{letters_for_number_3}"

  # Find the candidates for the mid and bottom
  mid_and_bottom_candidates = letters_for_number_3 - [top_position] - right_column_candidates
  puts "mid_and_bottom_candidates: #{mid_and_bottom_candidates}"


  # Find the candidates for left column
  left_column_candidates = ["a","b","c","d","e","f","g"] - right_column_candidates - mid_and_bottom_candidates - [top_position]
  puts "left_column_candidates  #{left_column_candidates}"




  # Between the 2 right_column_candidates, only bottom_right_position is part of 0,6,9 (6 digit signals)
  six_digit_signals = signal_patterns.select{|sp| sp.size == 6}
  bottom_right_position = right_column_candidates.select{|c|six_digit_signals.all?{|s| s.include?(c)}}.first
  top_right_position = (right_column_candidates - [bottom_right_position]).first
  raise "STOP" if (right_column_candidates - [bottom_right_position]).size != 1
  puts "bottom_right_position: #{bottom_right_position}"
  puts "top_right_position: #{top_right_position}"

  # Between the 2 mid_and_bottom_candidates, only the bottom_position is part of 0,6,9 (6 digit signals)
  bottom_position = mid_and_bottom_candidates.select{|c|six_digit_signals.all?{|s| s.include?(c)}}.first
  mid_position = (mid_and_bottom_candidates - [bottom_position]).first
  raise "STOP" if (mid_and_bottom_candidates - [bottom_position]).size != 1
  puts "bottom_position: #{bottom_position}"
  puts "mid_position: #{mid_position}"

  # Between the 2 left_column_candidates, only the top_left_position is part of 0,6,9 (6 digit signals)
  top_left_position = left_column_candidates.select{|c|six_digit_signals.all?{|s| s.include?(c)}}.first
  bottom_left_position = (left_column_candidates - [top_left_position]).first
  raise "STOP" if (left_column_candidates - [top_left_position]).size != 1
  puts "top_left_position: #{top_left_position}"
  puts "bottom_left_position: #{bottom_left_position}"


  result = ""
  output_values.each do |output_value|
    if output_value.size == 2
      result << "1"
    elsif output_value.size == 3
      result << "7"
    elsif output_value.size == 7
      result << "8"
    elsif output_value.size == 4
      result << "4"
    elsif output_value.size == 6
      # It can be either a 0, 6 or 9
      if !output_value.include?(mid_position)
        result << "0"
      elsif output_value.include?(top_right_position)
        result << "9"
      else
        result << "6"
      end
    elsif output_value.size == 5
      # It can be either a 2, 3 or 5
      if output_value.include?(top_left_position)
        result << "5"
      elsif output_value.include?(bottom_left_position)
        result << "2"
      else
        result << "3"
      end
    else
      puts "Numbers with size #{output_value.size} not implemented"
    end
  end

  puts "#{output_values.join(' ')}: #{result.to_i}"
  total += result.to_i
end

puts "\n\nTOTAL: #{total}"


