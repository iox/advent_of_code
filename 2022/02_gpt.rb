# Parse the strategy guide as a hash where the keys are the opponent's
# choice and the values are the corresponding response
strategy = {}
File.readlines("02_input").each do |line|
  opponent, response = line.split
  strategy[opponent] = response
end

# Define the outcome of a round as a lambda function
outcome = lambda do |opponent, response|
  # Return 0 if you lose
  return 0 if (opponent == "A" && response == "Z") ||
              (opponent == "B" && response == "X") ||
              (opponent == "C" && response == "Y")

  # Return 3 if the round is a draw
  return 3 if opponent == response

  # Otherwise, return 6 because you win
  6
end

# Read the list of rounds
rounds = File.readlines("02_input")

# Calculate the total score
total_score = rounds.reduce(0) do |score, round|
  # Parse the round
  opponent = round.strip

  # Look up the response for this round in the strategy guide
  response = strategy[opponent]

  # Calculate the score for this round using the outcome lambda function
  round_score = [1, 2, 3]["ABC".index(response)] + outcome.call(opponent, response)

  # Add the round score to the total score
  score + round_score
end

# Print the total score
puts total_score