rounds = File.read('02_input').split("\n")

total = 0

mine = {
  "X" => :rock,
  "Y" => :paper,
  "Z" => :scissors
}

op = {
  "A" => :rock,
  "B" => :paper,
  "C" => :scissors
}




def calculate(o, m)
  score = 0

  # Win condition
  if o == :rock && m == :paper || o == :paper && m == :scissors || o == :scissors && m == :rock
    score += 6
  end

  # Draw condition
  score += 3 if o == m

  # Shape points
  score += 1 if m == :rock
  score += 2 if m == :paper
  score += 3 if m == :scissors

  return score
end


rounds.each do |r|
  o = op[r.split(" ")[0]]
  m = mine[r.split(" ")[1]]
  result = calculate(o, m)
  total += result
end

puts total






def calculate2(o, goal)
  if o == :rock && goal == :lose
    m = :scissors
  elsif o == :rock && goal == :draw
    m = :rock
  elsif o == :rock && goal == :win
    m = :paper
  elsif o == :paper && goal == :lose
    m = :rock
  elsif o == :paper && goal == :draw
    m = :paper
  elsif o == :paper && goal == :win
    m = :scissors
  elsif o == :scissors && goal == :lose
    m = :paper
  elsif o == :scissors && goal == :draw
    m = :scissors
  elsif o == :scissors && goal == :win
    m = :rock
  end

  calculate(o,m)
end


goals = {
  "X" => :lose,
  "Y" => :draw,
  "Z" => :win
}

total = 0
rounds.each do |r|
  o = op[r.split(" ")[0]]
  goal = goals[r.split(" ")[1]]
  result = calculate2(o, goal)
  total += result
end

puts total