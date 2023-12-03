# watch -c "rspec 02_code.rb --force-color"

examples = File.readlines('02_example').map(&:chomp)

input = File.readlines('02_input').map(&:chomp)



def is_possible(game)
  reveals = game.split(": ")[1].split("; ")
  reveals.each do |reveal|
    groups = reveal.split(', ')
    groups.each do |group|
      color = group.split(" ")[1]
      value = group.split(" ")[0].to_i
      return false if color == "red" && value > 12
      return false if color == "green" && value > 13
      return false if color == "blue" && value > 14
    end
  end
  return true
end

def id_sum(games)
  result = 0

  games.each_with_index do |game, index|
    if is_possible(game)
      result += index + 1
    end
  end


  result
end



require 'rspec'
describe 'possible_games' do
  it 'determines if a game is possible' do
    expect(is_possible(examples[0])).to be_truthy
    expect(is_possible(examples[1])).to be_truthy
    expect(is_possible(examples[2])).to be_falsey
    expect(is_possible(examples[3])).to be_falsey
    expect(is_possible(examples[4])).to be_truthy
  end
end

describe 'id_sum' do
  it 'sums ids of possible games' do
    expect(id_sum(examples)).to eq 8
  end
end


def game_power(game)
  max_red = 1
  max_blue = 1
  max_green = 1
  reveals = game.split(": ")[1].split("; ")
  reveals.each do |reveal|
    groups = reveal.split(', ')
    groups.each do |group|
      color = group.split(" ")[1]
      value = group.split(" ")[0].to_i
      max_red = value   if color == "red"   && value > max_red
      max_green = value if color == "green" && value > max_green
      max_blue = value  if color == "blue"  && value > max_blue
    end
  end
  return max_red * max_green * max_blue
end

def power_sum(games)
  games.sum{|game| game_power(game)}
end


describe 'game_power' do
  it 'calculates the game power of a game' do
    expect(game_power(examples[0])).to eq 48
    expect(game_power(examples[1])).to eq 12
    expect(game_power(examples[2])).to eq 1560
    expect(game_power(examples[3])).to eq 630
    expect(game_power(examples[4])).to eq 36
  end
end


describe 'power_sum' do
  it 'sums powers' do
    expect(power_sum(examples)).to eq 2286
  end
end


# Part 1
# puts id_sum(input)

# Part 2
puts power_sum(input)