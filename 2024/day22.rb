def calculate_next(number, iterations: 1)
  iterations.times do
    new_number = number*64
    number = mix(number, new_number)
    number = prune(number)

    new_number = number/32
    number = mix(number, new_number)
    number = prune(number)

    new_number = number*2048
    number = mix(number, new_number)
    number = prune(number)
  end
  number
end


def mix(secret, value)
  secret ^ value
end

def prune(secret)
  secret % 16777216
end

def part1(input)
  input.split("\n").map(&:strip).map(&:to_i).map do |number|
    calculate_next(number, iterations: 2000)
  end.reduce(:+)
end






def buyers_prices(input, iterations: 1)
  buyers_prices = []
  input.split("\n").map(&:strip).map(&:to_i).map do |number|
    prices = []
    iterations.times do
      prices << number.to_s.chars.last.to_i
      number = calculate_next(number, iterations: 1)
      # puts "Number is #{number}"
    end
    buyers_prices << prices
  end
  buyers_prices
end

def buyers_price_changes(input, iterations: 1)
  buyers_prices = buyers_prices(input, iterations: iterations)
  buyers_price_changes = []
  buyers_prices.each do |prices|
    changes = []
    prices.each_with_index do |price, index|
      next if index == 0
      changes << price - prices[index-1]
    end
    buyers_price_changes << changes
  end
  buyers_price_changes
end



def simulate_sales(prices, changes, option)
  # puts "\nPrices: #{prices}"
  changes.each_cons(4).each_with_index do |change, index|
    if change == option
      # puts "Found option #{option} at index #{index}"
      sell_point_index = index + 4
      price_at_sell_point = prices[sell_point_index]
      # puts "OLD Price at sell point: #{price_at_sell_point} in index #{sell_point_index}"
      return price_at_sell_point
    end
  end
end


# You're going to need as many bananas as possible, so you'll need to determine which sequence of four price changes will cause the monkey to get you the most bananas overall

# you can only give the monkey a single sequence of four price changes to look for. You can't change the sequence between buyers.
def max_bananas(input, iterations: 1)
  buyers_prices = buyers_prices(input, iterations: iterations)
  buyers_price_changes = buyers_price_changes(input, iterations: iterations)

  benefits_memory = Hash.new(0)
  buyers_price_changes.each_with_index do |changes, buyer_index|
    puts "Buyer index: #{buyer_index} / #{buyers_price_changes.size}" if buyer_index % 100 == 0
    prices = buyers_prices[buyer_index]
    options = changes.each_cons(4).to_a#.uniq
    new_memory = {}
    options.each_with_index do |option, index|
      next if new_memory.key?(option)
      sell_point_index = index + 4
      price_at_sell_point = prices[sell_point_index]
      new_memory[option] = price_at_sell_point
      # puts "NEW Price at sell point: #{price_at_sell_point} in index #{sell_point_index}"

      # benefits_memory[option] += simulate_sales(prices, changes, option)
      # benefit = simulate_sales(prices, changes, option)
      # puts "Option: #{option} Benefit: #{benefit}"
    end
    new_memory.each do |option, benefit|
      benefits_memory[option] += benefit
    end
  end

  # puts "benefits_memory:"
  # require 'json'
  # puts JSON.pretty_generate(benefits_memory)

  # puts "buyers_price_changes: #{buyers_price_changes}"

  # Now I need to return the value from benefits_memory with the highest value


  # Print the key to console
  puts benefits_memory.key(benefits_memory.values.max).inspect
  benefits_memory.values.max
end



def part2(input)
  max_bananas(input, iterations: 2000)
end








puts part1(File.read("day22.txt"))
puts part2(File.read("day22.txt"))


require 'minitest/autorun'
require 'minitest/color'

class TestDay3 < Minitest::Test

  def sample
    <<-EOF
    1
    10
    100
    2024
    EOF
  end

  def sample_b
    <<-EOF
    1
    2
    3
    2024
    EOF
  end
  def test_part1
    assert_equal 37, mix(42, 15)

    assert_equal 16113920, prune(100000000)

    assert_equal 15887950, calculate_next(123, iterations: 1)
    assert_equal 16495136, calculate_next(123, iterations: 2)
    assert_equal 527345, calculate_next(123, iterations: 3)
    assert_equal 704524, calculate_next(123, iterations: 4)
    assert_equal 1553684, calculate_next(123, iterations: 5)
    assert_equal 12683156, calculate_next(123, iterations: 6)
    assert_equal 11100544, calculate_next(123, iterations: 7)
    assert_equal 12249484, calculate_next(123, iterations: 8)
    assert_equal 7753432, calculate_next(123, iterations: 9)
    assert_equal 5908254, calculate_next(123, iterations: 10)

    assert_equal 8685429, calculate_next(1, iterations: 2000)
    assert_equal 4700978, calculate_next(10, iterations: 2000)
    assert_equal 15273692, calculate_next(100, iterations: 2000)
    assert_equal 8667524, calculate_next(2024, iterations: 2000)
    
    assert_equal 37327623, part1(sample)
  end

  def test_part2
    assert_equal [[3, 0, 6, 5, 4, 4, 6, 4, 4, 2]], buyers_prices("123", iterations: 10)
    assert_equal [[-3, 6, -1, -1, 0, 2, -2, 0, -2]], buyers_price_changes("123", iterations: 10)

    assert_equal 6, max_bananas("123", iterations: 10)
    assert_equal 23, max_bananas(sample_b, iterations: 2000)
  end
end