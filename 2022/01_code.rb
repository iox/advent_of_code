puts File.read('01_input').split("\n\n").map{|b| b.split("\n").map(&:to_i).sum}.max


puts File.read('01_input').split("\n\n").map{|b| b.split("\n").map(&:to_i).sum}.max(3).sum


# numbers = File.readlines('01_input').map(&:to_i)

# prev = nil
# times = 0

# numbers.each do |n|
#   if prev && prev < n
#     times += 1
#   end
#   prev = n
# end

# puts times



# prev = nil
# times = 0

# numbers.each_with_index do |n,i|
#   if numbers[i+2]
#     sum = numbers[i] + numbers[i+1] + numbers[i+2]
#   end
#   if prev && sum && prev < sum
#     times += 1
#   end
#   prev = sum
# end

# puts times




# numbers.each do |first_number|
#   numbers.each do |second_number|
#     numbers.each do |third_number|
#       if first_number+second_number+third_number == 2021
#         puts first_number * second_number * third_number
#         exit
#       end
#     end
    
#   end
# end


# chars = File.read('01_input').chars

# floor = 0
# position = 1
# chars.each do |char|
#   floor += 1 if char == '('
#   floor -= 1 if char == ')'
#   puts "Position #{position}" if floor == -1
#   position += 1
# end
# puts floor



  
# def calc(op)
#   l,w,h = op.split("x").map(&:to_i)
#   a = (2*l*w)
#   b = (2*w*h)
#   c = (2*h*l)
  
#   # puts a
#   # puts b
#   # puts c
#   return (2*l*w) + (2*w*h) + (2*h*l) + ([a,b,c].min/2)
# end


# raise "NOPE" unless calc("1x1x10") == 43
# raise "NOPE" unless calc("2x3x4") == 58



# operations = File.readlines('01_input')
# total = 0
# operations.each do |op|
#   total += calc(op)
# end
# puts total




# def calc2(op)
#   l,w,h = op.split("x").map(&:to_i)
#   small = [l,w,h].sort[0]
#   medium = [l,w,h].sort[1]

#   wrap_length = small+small+medium+medium
#   bow_length = l*w*h

#   wrap_length + bow_length
# end


# raise "NOPE" unless calc2("2x3x4") == 34
# raise "NOPE" unless calc2("1x1x10") == 14


# operations = File.readlines('01_input')
# total = 0
# operations.each do |op|
#   total += calc2(op)
# end
# puts total