input = File.read('04_input').split("\n\n")
order = input[0].split(",").map(&:to_i)
boards = input.drop(1).map{|b| b.split("\n").map{|l| l.split().map(&:to_i)}}


# Part 1
winner_board = nil
called_numbers = []

order.each do |number|
  break if winner_board
  called_numbers << number

  boards.each do |board|
    lines_and_columns = board + board.transpose
    if lines_and_columns.any?{|l| l.all?{|n| called_numbers.include?(n)}}
      winner_board = board
      break
    end
  end
end

puts (winner_board.flatten - called_numbers).sum * called_numbers.last







# Part 2

winner_board = nil
called_numbers = []

order.each do |num|
  break if boards.size == 0
  called_numbers << num

  boards.each do |board|
    lines_and_columns = board + board.transpose
    if lines_and_columns.any?{|l| l.all?{|n| called_numbers.include?(n)}}
      winner_board = board
      boards.delete(board)
    end
  end
end


puts (winner_board.flatten - called_numbers).sum * called_numbers.last
