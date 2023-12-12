# watch -c "rspec 03_code.rb --force-color"

examples = File.readlines('03_example').map(&:chomp)
input = File.readlines('03_input').map(&:chomp)


def parts_sum(lines)
  sum = 0
  lines.each_with_index do |line, y|
    numbers = number_scanner(line)
    numbers.each do |n|
      sum += n[1] if part_validator(lines, y, n)
    end
  end

  sum
end

def number_scanner(line)
  line.enum_for(:scan, /\d+/).map { |match| [$~.offset(0)[0], match.to_i] }
end


def number_positions(line, number)
  result = []
  index = number[0]
  value = number[1]

  value.to_s.chars.size.times do |i|
    result << index + i
  end

  result
end


def find_adjacents(lines,y,x)
  adjacents = []

  if y > 0 #top row
    top_line = lines[y-1]
    adjacents << top_line[x-1] if x > 0
    adjacents << top_line[x]
    adjacents << top_line[x+1] if x < top_line.size - 1
  end

  current_line = lines[y]
  adjacents << current_line[x-1] if x > 0
  adjacents << current_line[x+1] if x < current_line.size - 1
  
  if y < (lines.size - 1)
    bottom_line = lines[y+1]
    adjacents << bottom_line[x-1] if x > 0
    adjacents << bottom_line[x]
    adjacents << bottom_line[x+1] if x < bottom_line.size - 1
  end

  return adjacents
end



def part_validator(lines, y, number)
  line = lines[y]
  positions = number_positions(line, number)

  adjacents = []
  positions.each do |x|
    adjacents += find_adjacents(lines,y,x)
  end
  adjacents.any?{|p| is_symbol(p) }
end


def is_symbol(p)
  !%w(0 1 2 3 4 5 6 7 8 9 .).include?(p)
end


describe 'find_adjacents' do
  it 'finds close together characters' do
    expect(find_adjacents(examples, 0, 0)).to eq ['6','.','.']
    expect(find_adjacents(examples, 1, 3)).to eq ['7','.','.','.','.','3','5','.']
    expect(find_adjacents(examples, 9, 9)).to eq ['.','.','.']
    expect(find_adjacents(examples, 9, 0)).to eq ['.','.','6']
  end
end


describe 'part_validator' do
  it 'validates parts' do
    expect(part_validator(examples, 0, [0, 467])).to eq true
    # expect(part_validator(examples, 2, 35)).to eq true
    # expect(part_validator(examples, 2, 633)).to eq true
    # expect(part_validator(examples, 4, 617)).to eq true
    # expect(part_validator(examples, 0, 114)).to eq false
    # expect(part_validator(examples, 5, 58)).to eq false
  end
end

describe 'number_scanner' do
  it 'extracts numbers and indexes out of string' do
    expect(number_scanner('...123')).to eq [[3, 123]]
    expect(number_scanner(examples[0])).to eq [
      [0, 467],
      [5, 114]
    ]
    expect(number_scanner(examples[1])).to eq []
    expect(number_scanner(examples[2])).to eq [
      [2, 35],
      [6, 633]
    ]
    expect(number_scanner('12...123..123')).to eq [
      [0, 12],
      [5, 123],
      [10, 123]
    ]
  end
end

describe 'number_positions' do
  it 'returns number positions in string' do
    expect(number_positions(examples[0], [0, 467])).to eq [0,1,2]
    expect(number_positions(examples[0], [5, 114])).to eq [5,6,7]
  end
end

describe 'parts_sum' do
  it 'sums parts' do
    expect(parts_sum(examples)).to eq 4361
  end
end

describe 'is_symbol' do
  it 'detects symbols' do
    expect(is_symbol('$')).to eq true
    expect(is_symbol('+')).to eq true
    expect(is_symbol('&')).to eq true
    expect(is_symbol('/')).to eq true
    expect(is_symbol('@')).to eq true
    expect(is_symbol('0')).to eq false
    expect(is_symbol('3')).to eq false
    expect(is_symbol('.')).to eq false
  end
end


puts parts_sum(input)




#################################################3

describe 'part2' do
  it 'sums gear ratios' do
    expect(part2(examples)).to eq 467835
  end
end


def part2(lines)
  sum = 0
  lines.each_with_index do |line, y|
    gear_positions = gear_scanner(line)
    gear_positions.each do |x|
      numbers = find_adjacent_numbers(lines, y, x)
      sum += numbers.reduce(:*) if numbers.size == 2
    end
  end

  sum
end


def gear_scanner(line)
  line.enum_for(:scan, '*').map { $~.offset(0)[0] }
end


def number_positions_part2(line, number)
  result = []
  index = number[0]
  value = number[1]

  result << index - 1
  value.to_s.chars.size.times do |i|
    result << index + i
  end
  result << index + value.to_s.chars.size

  result
end



def find_adjacent_numbers(lines,y,x)
  adjacents = []

  # Line on top
  top_numbers = lines[y-1] ? number_scanner(lines[y-1]) : []
  top_numbers.each do |n|
    positions = number_positions_part2(lines[y-1], n)
    if positions.include?(x)
      adjacents << n[1]
    end
  end

  # Numbers in same line
  same_line_numbers = number_scanner(lines[y])
  same_line_numbers.each do |n|
    positions = number_positions_part2(lines[y], n)
    if positions.include?(x)
      adjacents << n[1]
    end
  end

  # Bottom numbers
  bottom_numbers = lines[y+1] ? number_scanner(lines[y+1]) : []
  bottom_numbers.each do |n|
    positions = number_positions_part2(lines[y+1], n)
    if positions.include?(x)
      adjacents << n[1]
    end
  end

  return adjacents
end


describe 'gears_scanner' do
  it 'extracts indexes out of string' do
    expect(gear_scanner('...**')).to eq [3,4]
  end
end


describe 'find_adjacent_numbers' do
  it 'finds adjacent numbers' do
    expect(find_adjacent_numbers(examples, 1, 0)).to eq [467]
    expect(find_adjacent_numbers(examples, 5, 6)).to eq [58]
    expect(find_adjacent_numbers(examples, 1, 3)).to eq [467, 35]
    expect(find_adjacent_numbers(examples, 0, 9)).to eq []
  end
end


puts part2(input)
