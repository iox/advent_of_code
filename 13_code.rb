module ChineseRemainder
  extend self

  def solve(mods, remainders)
    max = mods.inject( :* )  # product of all moduli
    series = remainders.zip(mods).map{ |r,m| (r * max * invmod(max/m, m) / m) }
    series.inject( :+ ) % max
  end

  def extended_gcd(a, b)
    last_remainder, remainder = a.abs, b.abs
    x, last_x, y, last_y = 0, 1, 1, 0
    while remainder != 0
      last_remainder, (quotient, remainder) = remainder, last_remainder.divmod(remainder)
      x, last_x = last_x - quotient*x, x
      y, last_y = last_y - quotient*y, y
    end
    return last_remainder, last_x * (a < 0 ? -1 : 1)
  end

  def invmod(e, et)
    g, x = extended_gcd(e, et)
    if g != 1
      raise 'Multiplicative inverse modulo does not exist!'
    end
    x % et
  end
end



def part1(example_data)
  earliest_time = example_data.split("\n")[0].to_i
  buses = example_data.split("\n")[1].split(",").map(&:to_i) - [0]

  wait_times = {}
  buses.each do |bus|
    wait_time = bus - earliest_time%bus
    wait_times[bus] = wait_time
  end

  earliest_bus = wait_times.group_by{|k, v| v}.min_by{|k, v| k}.last.to_h

  earliest_bus.to_a.first
end







def part2(data)
  buses = data.split(",").map(&:to_i)

  mods = []
  remainders = []

  buses.each_with_index do |bus, index|
    if bus != 0
      mods << bus
      remainders << index*-1
    end
  end

  ChineseRemainder.solve(mods, remainders)



  # result = nil
  # (1..9_999_999_999_999_999).each do |iteration|

  #   start = buses.first * (iteration)
  #   success = buses.each_index.all? do |index|
  #     bus = buses[index]
  #     next true if bus == 0

  #     target_number = start + index
  #     target_number % bus == 0
  #   end

  #   if success
  #     result = start
  #     break
  #   end
  # end

  # result
end





  # The number I am looking for needs to be divisible by the first bus

  # The number + 1 must be divisible by index 2 of the array
  
  # The number + 3 must be disibible by index 3 of the array






def example_data
<<-EXAMPLE
939
7,13,x,x,59,x,31,19
EXAMPLE
end


if ARGV.include?('test')
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    def test_part1
      assert_equal([59, 5], part1(example_data))
    end

    def test_part2
      assert_equal(54, part2("3,5,7"))
      assert_equal(49, part2("7,5,3"))
      assert_equal(3417, part2("17,x,13,19"))
      assert_equal(754018, part2("67,7,59,61"))
      assert_equal(779210, part2("67,x,7,59,61"))
      assert_equal(1261476, part2("67,7,x,59,61"))
      assert_equal(1202161486, part2("1789,37,47,1889"))
      assert_equal(1068781, part2("7,13,x,x,59,x,31,19"))
    end
  end

end

data = File.read('13_input')
puts "Part 1: #{part1(data).reduce(:*)}"

puts "Part 2: #{part2(data.split("\n")[1])}"



