# watch -c "rspec day1.rb --force-color"

def part1(input)
  entries = input.split("\n").map(&:strip).map{|s| s.split("   ").map(&:to_i)}
  left_list = entries.map{|e| e.first}.sort
  right_list = entries.map{|e| e.last}.sort
  total_distance = 0
  left_list.each.with_index do |entry, index|
    distance = (entry - right_list[index]).abs
    # puts "The distance between #{entry} and #{right_list[index]} is #{distance}"
    total_distance += distance
  end

  # puts "total_distance: #{total_distance}"
  
  total_distance
end




def part2(input)
  entries = input.split("\n").map(&:strip).map{|s| s.split("   ").map(&:to_i)}
  left_list = entries.map{|e| e.first}
  right_list = entries.map{|e| e.last}
  total_score = 0
  left_list.each.with_index do |entry, index|
    score = entry * right_list.count(entry)
    # puts "The score for #{entry} is #{score}"
    total_score += score
  end

  # puts "total_score: #{total_score}"
  
  total_score
end


puts part1(File.read('day1.txt'))
puts part2(File.read('day1.txt'))



require 'rspec'
describe 'day1' do
  it 'solves part 1 and 2' do
    sample = <<-EOF
      3   4
      4   3
      2   5
      1   3
      3   9
      3   3
      EOF
    puts sample

    expect(part1(sample)).to eq(11)
    expect(part2(sample)).to eq(31)
  end
end
