numbers = File.readlines('01_input').map(&:to_i)

numbers.each do |first_number|
  numbers.each do |second_number|
    numbers.each do |third_number|
      if first_number+second_number+third_number == 2020
        puts first_number * second_number * third_number
        exit
      end
    end
    
  end
end