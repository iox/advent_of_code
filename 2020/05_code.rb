lines = File.readlines('05_input').map(&:chomp)


def decode(boarding_pass)
  row_binary = boarding_pass[0,7].gsub("F", "0").gsub("B", "1")
  column_binary = boarding_pass[7,3].gsub("L", "0").gsub("R", "1")
  
  return row_binary.to_i(2), column_binary.to_i(2)
end



if ARGV.include?('test')
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    def test_calculate
      
      assert_equal([44, 5], decode('FBFBBFFRLR'))
      assert_equal([70, 7], decode('BFFFBBFRRR'))
      assert_equal([14, 7], decode('FFFBBBFRRR'))
      assert_equal([102, 4], decode('BBFFBBFRLL'))
    end
  end

  return
end



ids = lines.map do |line|
  row, column = decode(line)
  row * 8 + column
end

part2 = nil
ids.sort!




ids.each_with_index do |id, index|
  next_id = ids[index+1]
  if next_id == id + 2
    part2 = id + 1
    break
  end
end





puts "Part 1: #{ids.max}"
puts "Part 2: #{part2}"
