def part1(data)
  result = find_a_seat_1(data: data, rounds: 900)
  result.count("#")
end



def find_a_seat_1(data:, rounds:)
  seatmap = data.split("\n").map{|line| line.split("")}
  
  round_counter = 0
  loop do
    break if round_counter == rounds
    round_counter += 1
    new_seatmap = Marshal.load( Marshal.dump(seatmap) )
    seatmap.each_with_index do |line, y|
      line.each_with_index do |value, x|

        surrounding_seats = [
          seatmap[y]&.at(x+1),
          seatmap[y+1]&.at(x),
          seatmap[y+1]&.at(x+1)
        ]

        if y>0
          surrounding_seats += [
            seatmap[y-1]&.at(x),
            seatmap[y-1]&.at(x+1),
          ]
        end

        if x>0
          surrounding_seats += [
            seatmap[y+1]&.at(x-1),
            seatmap[y]&.at(x-1),
          ]
        end

        if y>0 && x>0
          surrounding_seats += [ seatmap[y-1]&.at(x-1) ]
        end

        if value == "L" && surrounding_seats.count("#") == 0
          new_seatmap[y][x] = "#"
        elsif value == "#" && surrounding_seats.count("#") >= 4
          new_seatmap[y][x] = "L"
        end

      end
    end
    seatmap = new_seatmap
  end

  seatmap.map{|line| line.join}.join("\n")+"\n"
end



def part2(data)
  result = find_a_seat_2(data: data, rounds: 100)
  result.count("#")
end



def find_a_seat_2(data:, rounds:)
  seatmap = data.split("\n").map{|line| line.split("")}
  width = seatmap[0].size
  height = seatmap.size
  
  round_counter = 0
  loop do
    break if round_counter == rounds
    round_counter += 1
    new_seatmap = Marshal.load( Marshal.dump(seatmap) )
    seatmap.each_with_index do |line, y|
      line.each_with_index do |value, x|

        if y==0 && x==4
          debug = true
          puts "\n\nDEBUG START y#{y}/x#{x}\n\n"
          puts seatmap.map{|line| line.join}.join("\n")+"\n"
          puts "\n\n"
        else
          debug = false
        end


        visible_seats = 0

        # Look up: Is the next seat up occupied?
        visible_seats += 1 if (y-1).downto(0).to_a.any?{|y| 
          break if seatmap[y][x] == "L"
          seatmap[y][x] == "#"
        }
        puts "after up #{visible_seats}" if debug

        # Look right: Is there any occupied seat with same y, but with x more than me?
        visible_seats += 1 if (x+1).upto(width-1).to_a.any?{|x| 
          break if seatmap[y][x] == "L"
          seatmap[y][x] == "#"
        }
        puts "after right #{visible_seats}" if debug

        # Look down: Is there any occupied seat with same x, but y more than me?
        visible_seats += 1 if (y+1).upto(height-1).to_a.any?{|y| 
          break if seatmap[y][x] == "L"
          seatmap[y][x] == "#"
        }
        puts "after down #{visible_seats}" if debug

        # Look left: Is there any occupied seat with same y, but with x less than me?
        visible_seats += 1 if (x-1).downto(0).to_a.any?{|x| 
          break if seatmap[y][x] == "L"
          seatmap[y][x] == "#"
        }
        puts "after left #{visible_seats}" if debug

        # Look up+right: Is there any occupied seat with a y less than me, and an x more than me?
        visible_seats += 1 if (1..100).to_a.any? do |diff|
          break if y-diff < 0
          seat = seatmap[y-diff]&.at(x+diff)
          break if seat.nil? || seat == "L"
          seat == "#"
        end
        puts "after up+right #{visible_seats}" if debug

        # Look down+right: Is there any occupied seat with a y more than me, and an x more than me?
        visible_seats += 1 if (1..100).to_a.any? do |diff|
          seat = seatmap[y+diff]&.at(x+diff)
          break if seat.nil? || seat == "L"
          seat == "#"
        end
        puts "after down+right #{visible_seats}" if debug

        # Look down+left: Is there any occupied seat with a y more than me, and an x less than me?
        visible_seats += 1 if (1..100).to_a.any? do |diff|
          break if x-diff < 0
          seat = seatmap[y+diff]&.at(x-diff)
          break if seat.nil? || seat == "L"
          seat == "#"
        end
        puts "after down+left #{visible_seats}" if debug

        # Look up+left: Is there any occupied seat with a y less than me, and an x less than me?
        visible_seats += 1 if (1..100).to_a.any? do |diff|
          break if y-diff < 0 || x-diff < 0
          seat = seatmap[y-diff]&.at(x-diff)
          break if seat.nil? || seat == "L"
          seat == "#"
        end
        puts "after up+left #{visible_seats}" if debug


        if value == "L" && visible_seats == 0
          new_seatmap[y][x] = "#"
        elsif value == "#" && visible_seats >= 5
          new_seatmap[y][x] = "L"
        end

      end
    end
    seatmap = new_seatmap
  end

  seatmap.map{|line| line.join}.join("\n")+"\n"
end












def example_data
<<-EXAMPLEINPUT
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
EXAMPLEINPUT
end


def example_data_round_1
<<-EXAMPLEINPUT
#.##.##.##
#######.##
#.#.#..#..
####.##.##
#.##.##.##
#.#####.##
..#.#.....
##########
#.######.#
#.#####.##
EXAMPLEINPUT
end

def example_data_round_2
<<-EXAMPLE
#.LL.L#.##
#LLLLLL.L#
L.L.L..L..
#LLL.LL.L#
#.LL.LL.LL
#.LLLL#.##
..L.L.....
#LLLLLLLL#
#.LLLLLL.L
#.#LLLL.##
EXAMPLE
end

def example_data_round_3
<<-EXAMPLE
#.##.L#.##
#L###LL.L#
L.#.#..#..
#L##.##.L#
#.##.LL.LL
#.###L#.##
..#.#.....
#L######L#
#.LL###L.L
#.#L###.##
EXAMPLE
end

def example_data_round_4
<<-EXAMPLE
#.#L.L#.##
#LLL#LL.L#
L.L.L..#..
#LLL.##.L#
#.LL.LL.LL
#.LL#L#.##
..L.L.....
#L#LLLL#L#
#.LLLLLL.L
#.#L#L#.##
EXAMPLE
end

def example_data_round_5
<<-EXAMPLE
#.#L.L#.##
#LLL#LL.L#
L.#.L..#..
#L##.##.L#
#.#L.LL.LL
#.#L#L#.##
..L.L.....
#L#L##L#L#
#.LLLLLL.L
#.#L#L#.##
EXAMPLE
end


def example_data_round_1b
<<-EXAMPLE
#.##.##.##
#######.##
#.#.#..#..
####.##.##
#.##.##.##
#.#####.##
..#.#.....
##########
#.######.#
#.#####.##
EXAMPLE
end

def example_data_round_2b
<<-EXAMPLE
#.LL.LL.L#
#LLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLL#
#.LLLLLL.L
#.LLLLL.L#
EXAMPLE
end

def example_data_round_3b
<<-EXAMPLE
#.L#.##.L#
#L#####.LL
L.#.#..#..
##L#.##.##
#.##.#L.##
#.#####.#L
..#.#.....
LLL####LL#
#.L#####.L
#.L####.L#
EXAMPLE
end

def example_data_round_4b
<<-EXAMPLE
#.L#.L#.L#
#LLLLLL.LL
L.L.L..#..
##LL.LL.L#
L.LL.LL.L#
#.LLLLL.LL
..L.L.....
LLLLLLLLL#
#.LLLLL#.L
#.L#LL#.L#
EXAMPLE
end

def example_data_round_5b
<<-EXAMPLE
#.L#.L#.L#
#LLLLLL.LL
L.L.L..#..
##L#.#L.L#
L.L#.#L.L#
#.L####.LL
..#.#.....
LLL###LLL#
#.LLLLL#.L
#.L#LL#.L#
EXAMPLE
end

def example_data_round_6b
<<-EXAMPLE
#.L#.L#.L#
#LLLLLL.LL
L.L.L..#..
##L#.#L.L#
L.L#.LL.L#
#.LLLL#.LL
..#.L.....
LLL###LLL#
#.LLLLL#.L
#.L#LL#.L#
EXAMPLE
end

if ARGV.include?('test')
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    def test_part1
      assert_equal(example_data_round_1, find_a_seat_1(data: example_data, rounds: 1))
      assert_equal(example_data_round_2, find_a_seat_1(data: example_data, rounds: 2))
      assert_equal(example_data_round_3, find_a_seat_1(data: example_data, rounds: 3))
      assert_equal(example_data_round_4, find_a_seat_1(data: example_data, rounds: 4))
      assert_equal(example_data_round_5, find_a_seat_1(data: example_data, rounds: 5))
      assert_equal(37, part1(example_data))
    end

    def test_part2
      assert_equal(example_data_round_1b, find_a_seat_2(data: example_data, rounds: 1))
      assert_equal(example_data_round_2b, find_a_seat_2(data: example_data, rounds: 2))
      assert_equal(example_data_round_3b, find_a_seat_2(data: example_data, rounds: 3))
      assert_equal(example_data_round_4b, find_a_seat_2(data: example_data, rounds: 4))
      assert_equal(example_data_round_5b, find_a_seat_2(data: example_data, rounds: 5))
      assert_equal(example_data_round_6b, find_a_seat_2(data: example_data, rounds: 6))
      assert_equal(26, part2(example_data))
    end

  end

end

data = File.read('11_input')
puts "Part 1: #{part1(data)}"
puts "Part 2: #{part2(data)}"