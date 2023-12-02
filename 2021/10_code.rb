lines = File.readlines('10_input')

close_delimiters_map = {
  "(" => ")",
  "[" => "]",
  "{" => "}",
  "<" => ">"
}

points_map = {
  ")" => 3,
  "]" => 57,
  "}" => 1197,
  ">" => 25137
}

total = 0

lines.each_with_index do |line, line_index|
  open_delimiters = []
  error = nil
  line.chars.each_with_index do |char, index|
    if ["(","[","{","<"].include?(char)
      open_delimiters << char
    end
    if [")","]","}",">"].include?(char)
      last_open_delimiter = open_delimiters.pop
      # puts "Last open delimiter: #{last_open_delimiter}, char #{char}"
      if char != close_delimiters_map[last_open_delimiter]
        total += points_map[char]
        error = "Line #{line_index} is corrupt"
        break
      end
    end

    # When we arrived to the end, check if we are incomplete
    # puts "index: #{index} #{line.size - 1}"
    if index == (line.size - 1)
      # puts "End?"
      error = "Line #{line_index} is incomplete"
      break
    end
  end

  if error
    # puts error
    next false
  else
    next true
  end
end


puts total













points_map = {
  ")" => 1,
  "]" => 2,
  "}" => 3,
  ">" => 4
}


scores = []
lines = lines.select.with_index do |line, line_index|
  open_delimiters = []
  error = nil
  line.chars.each_with_index do |char, index|
    if ["(","[","{","<"].include?(char)
      open_delimiters << char
    end
    if [")","]","}",">"].include?(char)
      last_open_delimiter = open_delimiters.pop
      # puts "Last open delimiter: #{last_open_delimiter}, char #{char}"
      if char != close_delimiters_map[last_open_delimiter]
        error = "Line #{line_index} is corrupt"
        break
      end
    end

    # When we arrived to the end, check if we are incomplete
    # puts "index: #{index} #{line.size - 1}"
    if index == (line.size - 1)
      # puts "End?"
      error = "Line #{line_index} is incomplete"


      missing = open_delimiters.map do |d|
        close_delimiters_map[d]
      end

      missing.reverse!

      score = 0

      missing.each do |char|
        score = score * 5
        # puts "Multiply the total score by 5 to get #{score}"
        score += points_map[char]
        # puts "  then add the value of #{char}(#{points_map[char]}) to get a new total score of #{score}.\n\n"
      end

      # puts "#{missing.join.inspect} - #{score} total points."
      scores << score

      break
    end
  end

  if error
    # puts error
    next false
  else
    next true
  end
end


# puts scores.inspect
puts scores.sort[scores.size / 2]