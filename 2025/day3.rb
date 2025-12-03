# watch -c "rspec day1.rb --force-color"

def part1(input)
  battery_banks = input.split("\n").map(&:strip)
  battery_banks.sum do |bank|
    highest_joltage(bank)
  end
end

def highest_joltage(bank)
  batteries = bank.chars.map(&:to_i)
  batteries_without_last_element = batteries[0..-2]
  first_unit = batteries_without_last_element.max
  first_unit_position = batteries.index(first_unit)
  batteries_for_next_unit = batteries[(first_unit_position + 1)..-1]
  second_unit = batteries_for_next_unit.max
  "#{first_unit}#{second_unit}".to_i
end

def highest_12_digit_joltage(bank)
  batteries = bank.chars.map(&:to_i)
  highest_joltage = []
  current_index = 0
  
  12.times do |index|
    last_possible_index = batteries.size - (12 - index)
    
    possible_range = batteries[current_index..last_possible_index]
    max_digit = possible_range.max
    max_digit_index = possible_range.index(max_digit)
    max_pos = current_index + max_digit_index
    
    highest_joltage << max_digit
    current_index = max_pos + 1
  end
  
  highest_joltage.join.to_i
end

def part2(input)
  battery_banks = input.split("\n").map(&:strip)
  battery_banks.sum do |bank|
    highest_12_digit_joltage(bank)
  end
end




puts part1(File.read('day3.txt'))
puts part2(File.read('day3.txt'))



require 'rspec'
describe 'day3' do
  it 'returns the highest joltage with 2 digits' do
    expect(highest_joltage('987654321111111')).to eq 98
    expect(highest_joltage('811111111111119')).to eq 89
    expect(highest_joltage('234234234234278')).to eq 78
    expect(highest_joltage('818181911112111')).to eq 92
  end
  it 'solves part 1 and 2' do
    sample = <<-EOF
      987654321111111
      811111111111119
      234234234234278
      818181911112111
      EOF

    expect(part1(sample)).to eq(357)
    expect(part2(sample)).to eq(3121910778619)
  end

  it 'returns the highest joltage with 12 digits' do
    expect(highest_12_digit_joltage('987654321111111')).to eq 987654321111
    expect(highest_12_digit_joltage('811111111111119')).to eq 811111111119
    expect(highest_12_digit_joltage('234234234234278')).to eq 434234234278
    expect(highest_12_digit_joltage('818181911112111')).to eq 888911112111
  end

end
