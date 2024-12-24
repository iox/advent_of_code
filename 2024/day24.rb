require 'set'


class Machine
  def initialize(input)
    @wires = {}
    @gates = []
    parse_input(input)
    simulate_gates
  end

  def parse_input(input)
    input.each_line do |line|
      if line.include?(':')
        wire, value = line.split(':').map(&:strip)
        @wires[wire] = value.to_i
      elsif line.include?('->')
        @gates << line.strip
      end
    end
  end

  def simulate_gates
    loop do
      break if @gates.empty?
      @gates.each do |gate|
        if gate.include?('AND')
          if process_and_gate(gate)
            @gates.delete(gate)
          end
        elsif gate.include?('XOR')
          if process_xor_gate(gate)
            @gates.delete(gate)
          end
        elsif gate.include?('OR')
          if process_or_gate(gate)
            @gates.delete(gate)
          end
        end
      end
    end
  end

  def process_and_gate(gate)
    input1, input2, output = parse_gate(gate, 'AND')
    if @wires[input1] && @wires[input2]
      @wires[output] = @wires[input1] & @wires[input2]
      return true
    end
    return false
  end

  def process_xor_gate(gate)
    input1, input2, output = parse_gate(gate, 'XOR')
    if @wires[input1] && @wires[input2]
      @wires[output] = @wires[input1] ^ @wires[input2]
      return true
    end
    return false
  end

  def process_or_gate(gate)
    input1, input2, output = parse_gate(gate, 'OR')
    if @wires[input1] && @wires[input2]
      @wires[output] = @wires[input1] | @wires[input2]
      return true
    end
    return false
  end

  def parse_gate(gate, operation)
    inputs, output = gate.split('->').map(&:strip)
    input1, input2 = inputs.split(operation).map(&:strip)
    [input1, input2, output]
  end

  def debug_wire_values
    @wires
  end

  def binary_result
    z_wires = @wires.select { |k, _| k.start_with?('z') }
    z_wires.sort.map { |_, v| v }.reverse.join
  end

  def decimal_result
    binary_result.to_i(2)
  end
end




def part1(input)
  machine = Machine.new(input)
  machine.decimal_result
end



def part2(input)
  wires = {}
  operations = []

  highest_z = "z00"
  data = input.split("\n")
  data.each do |line|
    if line.include?(":")
      wire, value = line.split(": ")
      wires[wire] = value.to_i
    elsif line.include?("->")
      op1, op, op2, _, res = line.split(" ")
      operations << [op1, op, op2, res]
      if res[0] == "z" && res[1..-1].to_i > highest_z[1..-1].to_i
        highest_z = res
      end
    end
  end

  wrong = Set.new
  operations.each do |op1, op, op2, res|
    if res[0] == "z" && op != "XOR" && res != highest_z
      wrong.add(res)
    end
    if op == "XOR" && !["x", "y", "z"].include?(res[0]) && !["x", "y", "z"].include?(op1[0]) && !["x", "y", "z"].include?(op2[0])
      wrong.add(res)
    end
    if op == "AND" && !["x00"].include?(op1) && !["x00"].include?(op2)
      operations.each do |subop1, subop, subop2, subres|
        if (res == subop1 || res == subop2) && subop != "OR"
          wrong.add(res)
        end
      end
    end
    if op == "XOR"
      operations.each do |subop1, subop, subop2, subres|
        if (res == subop1 || res == subop2) && subop == "OR"
          wrong.add(res)
        end
      end
    end
  end
  wrong.to_a.sort.join(",")
end








puts part1(File.read("day24.txt"))
puts part2(File.read("day24.txt"))



# require 'minitest/autorun'
# require 'minitest/color'

# class TestDay3 < Minitest::Test
#   def small_sample
#     <<-EOF
#     x00: 1
#     x01: 1
#     x02: 1
#     y00: 0
#     y01: 1
#     y02: 0

#     x00 AND y00 -> z00
#     x01 XOR y01 -> z01
#     x02 OR y02 -> z02
#     EOF
#   end

#   def small_sample_wire_values
#     {
#     "x00" => 1,
#     "x01" => 1,
#     "x02" => 1,
#     "y00" => 0,
#     "y01" => 1,
#     "y02" => 0,
#     "z00" => 0,
#     "z01" => 0,
#     "z02" => 1
#     }
#   end

#   def large_sample
#     <<-EOF
#     x00: 1
#     x01: 0
#     x02: 1
#     x03: 1
#     x04: 0
#     y00: 1
#     y01: 1
#     y02: 1
#     y03: 1
#     y04: 1

#     ntg XOR fgs -> mjb
#     y02 OR x01 -> tnw
#     kwq OR kpj -> z05
#     x00 OR x03 -> fst
#     tgd XOR rvg -> z01
#     vdt OR tnw -> bfw
#     bfw AND frj -> z10
#     ffh OR nrd -> bqk
#     y00 AND y03 -> djm
#     y03 OR y00 -> psh
#     bqk OR frj -> z08
#     tnw OR fst -> frj
#     gnj AND tgd -> z11
#     bfw XOR mjb -> z00
#     x03 OR x00 -> vdt
#     gnj AND wpb -> z02
#     x04 AND y00 -> kjc
#     djm OR pbm -> qhw
#     nrd AND vdt -> hwm
#     kjc AND fst -> rvg
#     y04 OR y02 -> fgs
#     y01 AND x02 -> pbm
#     ntg OR kjc -> kwq
#     psh XOR fgs -> tgd
#     qhw XOR tgd -> z09
#     pbm OR djm -> kpj
#     x03 XOR y03 -> ffh
#     x00 XOR y04 -> ntg
#     bfw OR bqk -> z06
#     nrd XOR fgs -> wpb
#     frj XOR qhw -> z04
#     bqk OR frj -> z07
#     y03 OR x01 -> nrd
#     hwm AND bqk -> z03
#     tgd XOR rvg -> z12
#     tnw OR pbm -> gnj
#     EOF
#   end


#   def sample_part2_wrong
#     <<-EOF
#     x00: 0
#     x01: 1
#     x02: 0
#     x03: 1
#     x04: 0
#     x05: 1
#     y00: 0
#     y01: 0
#     y02: 1
#     y03: 1
#     y04: 0
#     y05: 1

#     x00 AND y00 -> z05
#     x01 AND y01 -> z02
#     x02 AND y02 -> z01
#     x03 AND y03 -> z03
#     x04 AND y04 -> z04
#     x05 AND y05 -> z00
#     EOF
#   end

#   def sample_part2_correct
#     <<-EOF
#     x00: 0
#     x01: 1
#     x02: 0
#     x03: 1
#     x04: 0
#     x05: 1
#     y00: 0
#     y01: 0
#     y02: 1
#     y03: 1
#     y04: 0
#     y05: 1

#     x00 AND y00 -> z00
#     x01 AND y01 -> z01
#     x02 AND y02 -> z02
#     x03 AND y03 -> z03
#     x04 AND y04 -> z04
#     x05 AND y05 -> z05
#     EOF
#   end


#   def test_part1
#     small_machine = Machine.new(small_sample)
#     assert_equal small_sample_wire_values, small_machine.debug_wire_values
#     assert_equal "100", small_machine.binary_result
#     assert_equal 4, small_machine.decimal_result


#     large_machine = Machine.new(large_sample)
#     assert_equal "0011111101000", large_machine.binary_result
#     assert_equal 2024, large_machine.decimal_result
#   end

#   def test_part2
#     wrong_machine = Machine.new(sample_part2_wrong)
#     assert_equal 9, wrong_machine.decimal_result

#     correct_machine = Machine.new(sample_part2_correct)
#     assert_equal 40, correct_machine.decimal_result
#   end
# end