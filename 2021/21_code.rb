position_1 = 4
position_2 = 7

score_1 = 0
score_2 = 0

total_roll_count = 0
die_value = 0

BOARD_LENGTH = 10


def turn(position, score, die_value, total_roll_count)

  # Roll
  movement = 0
  3.times do
    total_roll_count += 1
    die_value += 1
    die_value = 1 if die_value > 100
    movement += die_value
  end

  # Move
  movement.times do
    position += 1
    if position > BOARD_LENGTH
      position = 1
    end
  end

  # Calculate score
  score += position

  return position, score, die_value, total_roll_count
end

loop do
  position_1, score_1, die_value, total_roll_count = turn(position_1, score_1, die_value, total_roll_count)
  break if score_1 >= 1000

  position_2, score_2, die_value, total_roll_count = turn(position_2, score_2, die_value, total_roll_count)
  break if score_2 >= 1000
end

puts [score_1, score_2].min * total_roll_count






# Part 2 is completely different. We can't loop so many times
# We need a smarter way to calculate this
# It's some kind of tree solution where we don't have to recalculate the same states a million times

# Let's start with the basics
position_1 = 4
position_2 = 7
@roll_permutations = [1, 2, 3].repeated_permutation(3).to_a

@partial_results = {}

def calculate_wins(position_1, position_2, score_1, score_2)
  # If the results are cached, return them immediately
  cached = @partial_results[[position_1, position_2, score_1, score_2]]
  return cached if cached

  win_count_this_loop_1, win_count_this_loop_2 = 0, 0

  @roll_permutations.each do |roll|
    current_position = position_1
    roll.sum.times do
      current_position += 1
      if current_position > BOARD_LENGTH
        current_position = 1
      end
    end
    current_score = score_1 + current_position
    if current_score >= 21
      win_count_this_loop_1 += 1
      next
    end
    
    temp2, temp1 = calculate_wins(position_2, current_position, score_2, current_score)
    win_count_this_loop_1 += temp1
    win_count_this_loop_2 += temp2
  end


  result = [win_count_this_loop_1, win_count_this_loop_2]
  @partial_results[[position_1, position_2, score_1, score_2]] = result
  result
end


puts calculate_wins(position_1, position_2, 0, 0)
# 568867175661958