# https://github.com/mrphlip/aoc/blob/master/2021/24.md

# https://github.com/firetech/advent-of-code/blob/%F0%9F%8E%84/2021/24/monad.rb

input = File.read('24_input').strip.split("\n").map do |line|
  i,a,b = line.split(" ")
  i = i.to_sym
  b = b.to_i unless (b.nil? || ["w","x","y","z"].include?(b))
  [i,a,b]
end


stack = []
@offsets = {}

input.each_slice(input.length/14).with_index do |subprogram, current_index|
  condition = subprogram[4][2]
  if condition == 1
    stack << [current_index, subprogram[15][2]]
  elsif condition == 26
    last_index, offset = stack.pop
    offset += subprogram[5][2]
    @offsets[current_index] = [last_index, offset]
  end
end


raise "HEY" unless stack.size == 0


@ranges = []
@offsets.each do |current_index, (last_index, offset)|
  if offset < 0
    last_index, current_index = current_index, last_index
    offset = - offset
  end
  @ranges[current_index] = (1 + offset)..9
  @ranges[last_index] = 1..(9 - offset)
end


puts @ranges.map { |l| l.max }.join
puts @ranges.map { |l| l.min }.join





# require 'set'

# input = File.read('24_input')

# example_three_times_larger = <<HERE
# inp z
# inp x
# mul z 3
# eql z x
# HERE


# example_multiply_minus_one = <<HERE
# inp x
# mul x -1
# HERE


# example_binary_converter = <<HERE
# inp w
# add z w
# mod z 2
# div w 2
# add y w
# mod y 2
# div w 2
# add x w
# mod x 2
# div w 2
# mod w 2
# HERE

# $cache = {}

# class Computer
  
#   attr_accessor :instructions, :inputs, :memory

#   def initialize(instructions, step, inputs, w=0, z=0)
#     cached = $cache[[step,w,z]]
#     return cached if cached

#     @instructions = instructions
#     # @inputs = inputs
#     @memory = {
#       "w" => w,
#       "x" => 0,
#       "y" => 0,
#       "z" => z
#     }
#     @input_index = 0

#     @instructions.each do |i|
#       process(i)
#       # puts "Processed line"
#     end

#     $cache[[step,w,z]] = z
#     return z
#   end

#   def process(i)
#     instruction,a,b = i

#     # if instruction == "inp"
#     #   raise "NOT ENOUGH INPUTS" if @inputs[@input_index].nil?
#     #   @memory[a] = @inputs[@input_index]
#     #   @input_index += 1
#     #   return
#     # end

#     b_value = @memory.keys.include?(b) ? @memory[b] : b.to_i

#     if instruction == "add"
#       @memory[a] = @memory[a] + b_value
#     elsif instruction == "mul"
#       @memory[a] = @memory[a] * b_value
#     elsif instruction == "div"
#       @memory[a] = @memory[a] / b_value
#     elsif instruction == "mod"
#       @memory[a] = @memory[a] % b_value
#     elsif instruction == "eql"
#       @memory[a] = @memory[a] == b_value ? 1 : 0
#     end
      
#   end
# end
 


# # raise "HEY" unless Computer.new(example_three_times_larger, [3,9]).memory["z"] == 1
# # raise "HEY" unless Computer.new(example_three_times_larger, [3,0]).memory["z"] == 0
# # raise "HEY" unless Computer.new(example_multiply_minus_one, [5]).memory["x"] == -5
# # raise "HEY" unless Computer.new(example_binary_converter, [5]).memory.values == [0,1,0,1]



# z_valid = Set.new
# z_valid << 0


# # correct = "97919997299495".chars.map(&:to_i)
# correct = "51619131181131".chars.map(&:to_i)

# (-14..-1).to_a.reverse.each do |step|
#   new_z_valid = Set.new
#   last = nil
#   partial_input = input.split("inp w")[step]
#   instructions = partial_input.split("\n").map{|i| i.split(" ")}
#   valid_inputs = []
#   puts "\n\nSolving step #{step}"
#   (0..10000000).each do |z|
#     break if last && z > (last + 2000000)

#     puts "   #{z} (found #{new_z_valid.size} new_z_valid)" if z % 100000 == 0
#     # [correct[step]].each do |w|
#     (1..9).each do |w|
#       # puts "Testing #{memory.inspect}"
#       result = Computer.new(instructions, step, [], w, z).memory["z"]
#       if z_valid.include?(result)
#         last = z
#         new_z_valid << z
#         valid_inputs << w unless valid_inputs.include?(w)
#         # puts "   SOLVED step #{step} with input #{w} and z #{z}"
#       end
#     end
#   end
#   z_valid = new_z_valid
#   puts "Finished step #{step} with #{z_valid.size} z_valid and inputs #{valid_inputs.sort}"
#   if z_valid.size < 30
#     puts z_valid.inspect
#   end
# end





# puts "OK"


# #

# # Stuff I understand
# # The input has 14 blocks, all quite similar
# # x and y are being set to 0 in each block. So basically a Z value is carried plus and 
# # There are 3 differences between each block, 3 integers
# #  One if a module which is either 1 or 26
# #  The other are 2 sums, where random numbers are added to x and y
