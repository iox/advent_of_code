test_lines = File.readlines('03_input_test').map(&:chomp)

def calc_gamma(lines)
  length = lines.first.length

  index = 0  
  result = ""


  length.times do
    position_content = []
    lines.each do |line|
      position_content << line[index]
    end


    result << position_content.max_by {|i| position_content.count(i)}
    
    index += 1
  end

  result.to_i(2)
end



def calc_epsilon(lines)
  length = lines.first.length

  index = 0  
  result = ""


  length.times do
    position_content = []
    lines.each do |line|
      position_content << line[index]
    end


    result << position_content.max_by {|i| position_content.count(i)*-1}
    
    index += 1
  end

  result.to_i(2)
end

test_lines = File.readlines('03_input_test').map(&:chomp)
# raise "NOPE" unless calc_gamma(test_lines) == 22
# raise "NOPE" unless calc_epsilon(test_lines) == 9


lines = File.readlines('03_input').map(&:chomp)

# puts calc_gamma(lines) * calc_epsilon(lines)


def calc_oxygen(lines)
  length = lines.first.length

  index = 0  
  length.times do
    position_content = []
    lines.each do |line|
      position_content << line[index]
    end

    # most_common = position_content.max_by {|i| position_content.count(i)*1}

    if position_content.count("0") > position_content.count("1")
      target = "0"
    else
      target = "1"
    end


    # Filter the lines
    lines = lines.select{|line| line[index] == target }

    puts lines.size
    
    if lines.size == 1
      result = lines.first.to_i(2)
      puts lines.first.inspect
      return result
      
    end
    index += 1
  end
end



def calc_scrubber(lines)
  length = lines.first.length

  index = 0  
  length.times do
    position_content = []
    lines.each do |line|
      position_content << line[index]
    end

    # most_common = position_content.max_by {|i| position_content.count(i)*1}

    if position_content.count("0") > position_content.count("1")
      target = "1"
    else
      target = "0"
    end


    # Filter the lines
    lines = lines.select{|line| line[index] == target }

    puts lines.size
    
    if lines.size == 1
      result = lines.first.to_i(2)
      puts lines.first.inspect
      return result
      
    end
    index += 1
  end
end








raise "NOPE" unless calc_oxygen(test_lines) == 23
raise "NOPE" unless calc_scrubber(test_lines) == 10



lines = File.readlines('03_input').map(&:chomp)
puts calc_oxygen(lines) * calc_scrubber(lines)