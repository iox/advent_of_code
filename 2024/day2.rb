# watch -c "rspec day2.rb --force-color"

def part1(input)
  count = 0

  input.split("\n").each do |line|
    count += 1 if is_safe(line)
  end
  count
end
  
# a report only counts as safe if both of the following are true:
# The levels are either all increasing or all decreasing.
# Any two adjacent levels differ by at least one and at most three.
def is_safe(line)
  values = values = line.strip.split(" ").map(&:to_i)
  return false if values.empty?

  increasing = true
  decreasing = true

  (1...values.length).each do |i|
    diff = values[i] - values[i - 1]
    return false if diff.abs < 1 || diff.abs > 3

    increasing = false if diff < 0
    decreasing = false if diff > 0
  end

  increasing || decreasing
end







def part2(input)
  count = 0

  input.split("\n").each do |line|
    count += 1 if is_safe_part2(line)
  end
  count
end


def is_safe_part2(line)
  values = values = line.strip.split(" ").map(&:to_i)
  return false if values.empty?

  return true if is_safe(line)
  
  values.each_with_index do |value, index|
    new_values = values.dup
    new_values.delete_at(index)
    new_line = new_values.map(&:to_s).join(" ")
    return true if is_safe(new_line)
  end

  return false
end





puts part1(File.read('day2.txt'))
puts part2(File.read('day2.txt'))



require 'rspec'
describe 'day2' do
  let(:sample) do
    <<-EOF
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
      EOF
  end
  it 'checks if a line is safe' do
    expect(is_safe("7 6 4 2 1")).to eq(true)
    expect(is_safe("1 2 7 8 9")).to eq(false)
    expect(is_safe("9 7 6 2 1")).to eq(false)
    expect(is_safe("1 3 2 4 5")).to eq(false)
    expect(is_safe("8 6 4 4 1")).to eq(false)
    expect(is_safe("1 3 6 7 9")).to eq(true)
    
    expect(part1(sample)).to eq(2)
  end

  it 'part2' do
    expect(is_safe_part2("7 6 4 2 1")).to eq(true)
    expect(is_safe_part2("1 2 7 8 9")).to eq(false)
    expect(is_safe_part2("9 7 6 2 1")).to eq(false)
    expect(is_safe_part2("1 3 2 4 5")).to eq(true)
    expect(is_safe_part2("8 6 4 4 1")).to eq(true)
    expect(is_safe_part2("1 3 6 7 9")).to eq(true)
    
    expect(part2(sample)).to eq(4)
  end
end
