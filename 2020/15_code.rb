def part1(numbers)
  play(numbers, 2020)
end

def part2(numbers)
  play(numbers, 30_000_000)
end


def play(numbers, turns)

  # I need to know how many times a number has been said, and in which turn
  mem = {}
  
  numbers.each_with_index do |number, index|
    mem[number] = {last_turn: index + 1, times: 1}
  end
  last_spoken = numbers.last

  # Play the game
  ((numbers.size + 1)..turns).each do |turn|
    if turn % 1000000 == 0
      # puts "We are in turn #{turn}"
    end

    data = mem[last_spoken].dup
    mem[last_spoken][:last_turn] = turn - 1

    
    # If that was the first time the number has been spoken,
    # the current player says 0.
    if data[:times] == 1
      last_spoken = 0
      mem[0] ||= {times: 0}
      mem[0][:times] += 1
      next
    end

    # Otherwise, the number had been spoken before; 
    # the current player announces how many turns apart
    # the number is from when it was previously spoken.
    last_spoken = turn - 1 - data[:last_turn]

    if mem[last_spoken]
      mem[last_spoken][:times] += 1
    else
      mem[last_spoken] = {times: 1}
    end
  end

  last_spoken
end







if ARGV.include?('test')
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    def test_play
      assert_equal(0, play([0,3,6], 4))
      assert_equal(3, play([0,3,6], 5))
      assert_equal(3, play([0,3,6], 6))
      assert_equal(1, play([0,3,6], 7))
      assert_equal(0, play([0,3,6], 8))
      assert_equal(4, play([0,3,6], 9))
      assert_equal(0, play([0,3,6], 10))
    end


    def test_part1
      assert_equal(436, part1([0,3,6]))
      assert_equal(1, part1([1,3,2]))
      assert_equal(10, part1([2,1,3]))
      assert_equal(27, part1([1,2,3]))
      assert_equal(78, part1([2,3,1]))
      assert_equal(438, part1([3,2,1]))
      assert_equal(1836, part1([3,1,2]))
    end


    def test_part2
      assert_equal(175594, part2([0,3,6]))
      assert_equal(2578, part2([1,3,2]))
      assert_equal(3544142, part2([2,1,3]))
      assert_equal(261214, part2([1,2,3]))
      assert_equal(6895259, part2([2,3,1]))
      assert_equal(18, part2([3,2,1]))
      assert_equal(362, part2([3,1,2]))
    end
  end
end

# play([0,3,6], 5)

# play([2,1,3], 2020)

# puts "Part 1: #{part1([1,0,18,10,19,6])}"
# puts "Part 2: #{part2([1,0,18,10,19,6])}"