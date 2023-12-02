number = 0
lines = File.read('01_input').split("\n")
lines.each do |line|
  number_chars = line.chars.select{|c| "0123456789".chars.include?(c)}
  number += (number_chars.first + number_chars.last).to_i
end

puts number





def convert_to_number(input)
  map = {
    'one' => '1',
    'two' => '2',
    'three' => '3',
    'four' => '4',
    'five' => '5',
    'six' => '6',
    'seven' => '7',
    'eight' => '8',
    'nine' => '9',
    '1' => '1',
    '2' => '2',
    '3' => '3',
    '4' => '4',
    '5' => '5',
    '6' => '6',
    '7' => '7',
    '8' => '8',
    '9' => '9',
  }

  first = map.keys.min_by{|k| input.index(k) || 9999 }
  last = map.keys.min_by{|k| input.reverse.index(k.reverse) || 9999 }
  (map[first] + map[last]).to_i
end

second_number = 0
lines.each do |line|
  second_number += convert_to_number(line)
end
puts second_number



require 'rspec'
describe 'convert_to_number' do
  it 'converts numbers' do
    expect(convert_to_number('two1nine')).to eq(29)
    expect(convert_to_number('eighttwothree')).to eq(83)
    expect(convert_to_number('abcone2threexyz')).to eq(13)
    expect(convert_to_number('xtwone3four')).to eq(24)
    expect(convert_to_number('4nineeightseven2')).to eq(42)
    expect(convert_to_number('zoneight234')).to eq(14)
    expect(convert_to_number('7pqrstsixteen')).to eq(76)
  end
end
