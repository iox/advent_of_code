def enhance(image, algorithm, default_value)
  output = []

  image.each_with_index do |line, y|
    new_line = []
    line.each_with_index do |char, x|
      square = [[-1,-1],[-1,0],[-1,1],[0,-1],[0,0],[0,1],[1,-1],[1,0],[1,1]].map do |(diff_y, diff_x)|
        neighbour_y = y+diff_y
        neighbour_x = x+diff_x
        # puts "neighbour_y #{neighbour_y} neighbour_x #{neighbour_x}" if y == 4
        next default_value if neighbour_y < 0 || neighbour_x < 0

        line = image[neighbour_y]
        next default_value if line.nil?

        char = line[neighbour_x]
        next default_value if char.nil?

        char
      end

      square_bits = square.join.gsub(".","0").gsub("#","1")
      new_line << algorithm[square_bits.to_i(2)]
    end
    
    output << new_line
  end

  output
end








input = File.read('20_input')

algorithm   = input.split("\n\n").first
image = input.split("\n\n").last.split("\n").map{|l| l.chars}



puts "\n\n"
image.each do |line|
  puts line.join
end
puts "\n\n"



2.times.with_index do |time_index|
  puts "Loop: #{time_index}"
  default_value = time_index % 2 == 0 ? "." : "#"

  # Make the map bigger
  image.map! do |line|
    # Add empty line at the start and end
    2.times do
      line.unshift(default_value)
      line.append(default_value)
    end
    line
  end
  empty_line = (default_value*image.first.size).chars
  # Add empty line at the start and end
  2.times do
    image.unshift(empty_line)
    image.append(empty_line)  
  end

  image = enhance(image, algorithm, default_value)

end



puts image.flatten.count("#")
