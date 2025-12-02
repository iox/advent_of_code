def part1(input)
  ranges = input.split(",").map{|r| r.split("-").map(&:to_i) }
  total = 0
  ranges.each do |start_num, end_num|
    (start_num..end_num).each do |num|
      num_str = num.to_s
      next if num_str.size % 2 != 0
      
      half = num_str.size / 2
      first_half = num_str[0...half]
      second_half = num_str[half..-1]
      next if first_half != second_half
      total += num
    end
  end
  total
end


def part2(input)
  ranges = input.split(",").map{|r| r.split("-").map(&:to_i) }
  total = 0
  ranges.each do |start_num, end_num|
    (start_num..end_num).each do |num|
      next unless repeating_pattern?(num)
      total += num
    end
  end
  total
end

def repeating_pattern?(num)
  num_str = num.to_s
  size = num_str.size
  (1..(size/2)).each do |seq_size|
    next if size % seq_size != 0
    seq = num_str[0...seq_size]
    times = size / seq_size
    return true if seq * times == num_str
  end
  false
end



puts part1(File.read('day2.txt'))

puts part2(File.read('day2.txt'))


require 'rspec'
describe 'day2' do
  it 'solves part' do
    expect(part1("11-22")).to eq(33)
    expect(part1("95-115")).to eq(99)
    expect(part1("11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124")).to eq(1227775554)
  end

  it 'solves part 2' do
    expect(part2("11-22")).to eq(33)
    expect(part2("95-115")).to eq(210)
    expect(part2("998-1012")).to eq(2009)
    expect(part2("1188511880-1188511890")).to eq(1188511885)
    expect(part2("222220-222224")).to eq(222222)
    expect(part2("1698522-1698528")).to eq(0)
    expect(part2("446443-446449")).to eq(446446)
    expect(part2("38593856-38593862")).to eq(38593859)
    expect(part2("565653-565659")).to eq(565656)
    expect(part2("824824821-824824827")).to eq(824824824)
    expect(part2("2121212118-2121212124")).to eq(2121212121)
    expect(part2("11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124")).to eq(4174379265)
  end
end
