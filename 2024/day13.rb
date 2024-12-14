require 'matrix'


def parser(input)
  input.split("\n\n").map do |block|
    a_x = 0
    a_y = 0
    b_x = 0
    b_y = 0
    prize_x = 0
    prize_y = 0
    block.split("\n").each do |line|
      if line.include?("Button A")
        a_x = line.split("X+")[1].split(",")[0].to_i
        a_y = line.split("Y+")[1].strip.to_i
      elsif line.include?("Button B")
        b_x = line.split("X+")[1].split(",")[0].to_i
        b_y = line.split("Y+")[1].strip.to_i
      else
        prize_x = line.split("X=")[1].split(",")[0].to_i
        prize_y = line.split("Y=")[1].strip.to_i
      end
    end

    {A: [a_x, a_y], B: [b_x, b_y], prize: [prize_x, prize_y]}
  end
end

def parser_part2(input)
  parsed = parser(input)
  parsed.map do |machine|
    machine[:prize][0] = 10000000000000 + machine[:prize][0]
    machine[:prize][1] = 10000000000000 + machine[:prize][1]
    machine
  end
end

def part1(input)
  machines = parser(input)
  solutions = machines.map {|m| solve(m)}.compact
  solutions.map {|s| (s[0] * 3) + s[1]}.reduce(:+)
end

def part2(input)
  machines = parser_part2(input)
  solutions = machines.map {|m| solve(m)}.compact
  solutions.map {|s| (s[0] * 3) + s[1]}.reduce(:+)
end

def solve(machine)
  a_x = machine[:A][0]
  a_y = machine[:A][1]
  b_x = machine[:B][0]
  b_y = machine[:B][1]
  prize_x = machine[:prize][0]
  prize_y = machine[:prize][1]
  # {A: [94,34], B: [22,67], prize: [8400, 5400]}

  # I need to find two numbers called a_multiplier and b_multiplier


  # These 2 numbers need to make true the following:

  # a_multiplier * a_x + b_multiplier * b_x == prize_x
  # a_multiplier * a_y + b_multiplier * b_y == prize_y


  # There is probably some fancy math here, but let's brute force it for now

  # (1..100).to_a.reverse.each do |b_multiplier|
  #   (1..100).to_a.each do |a_multiplier|
  #     if (a_multiplier * a_x + b_multiplier * b_x == prize_x) && (a_multiplier * a_y + b_multiplier * b_y == prize_y)
  #       return [a_multiplier, b_multiplier]
  #     end
  #   end
  # end


  # 8400  94  22

  # 94*80 + 22*40 = 8400


  # A * 94 + B * 22 = 8400
  # A * 34 + B * 67 = 5400


  # Coefficients of the equations
  coefficients = Matrix[[a_x, b_x], [a_y, b_y]]

  # Constants on the right-hand side of the equations
  constants = Vector[prize_x, prize_y]

  # Solve for the variables A and B
  solution = coefficients.inverse * constants

  # Extract the values of A and B
  a = solution[0]
  b = solution[1]

  # Output the results
  # puts "A = #{a}"
  # puts "B = #{b}"

  if a % 1 == 0 && b % 1 == 0
    return [a, b]
  else
    return nil
  end
end


puts part1(File.read("day13.txt"))
puts part2(File.read("day13.txt"))



require 'minitest/autorun'
require 'minitest/color'

class TestDay3 < Minitest::Test
  def sample
    <<-EOF
    Button A: X+94, Y+34
    Button B: X+22, Y+67
    Prize: X=8400, Y=5400

    Button A: X+26, Y+66
    Button B: X+67, Y+21
    Prize: X=12748, Y=12176

    Button A: X+17, Y+86
    Button B: X+84, Y+37
    Prize: X=7870, Y=6450

    Button A: X+69, Y+23
    Button B: X+27, Y+71
    Prize: X=18641, Y=10279
    EOF
  end

  def sample_machines_part2
    [
      {A: [94,34], B: [22,67], prize: [10000000008400, 10000000005400]},
      {A: [26,66], B: [67,21], prize: [10000000012748, 10000000012176]},
      {A: [17,86], B: [84,37], prize: [10000000007870, 10000000006450]},
      {A: [69,23], B: [27,71], prize: [10000000018641, 10000000010279]}
    ]
  end

  def sample_machines
    [
      {A: [94,34], B: [22,67], prize: [8400, 5400]},
      {A: [26,66], B: [67,21], prize: [12748, 12176]},
      {A: [17,86], B: [84,37], prize: [7870, 6450]},
      {A: [69,23], B: [27,71], prize: [18641, 10279]}
    ]
  end

  def test_parser
    machines = parser(sample)
    assert_equal 4, machines.size

    assert_equal sample_machines[0], machines[0]
    assert_equal sample_machines[1], machines[1]
    assert_equal sample_machines[2], machines[2]
    assert_equal sample_machines[3], machines[3]
  end

  def test_parser_part2
    machines = parser_part2(sample)
    assert_equal 4, machines.size

    assert_equal sample_machines_part2[0], machines[0]
    assert_equal sample_machines_part2[1], machines[1]
    assert_equal sample_machines_part2[2], machines[2]
    assert_equal sample_machines_part2[3], machines[3]
  end

  def test_solve
    assert_equal [80,40], solve(sample_machines[0])
    assert_nil solve(sample_machines[1])
    assert_equal [38,86], solve(sample_machines[2])
    assert_nil solve(sample_machines[3])

    assert_equal 480, part1(sample)
  end

end