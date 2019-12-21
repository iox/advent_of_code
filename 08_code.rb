#! /usr/bin/env ruby

module Something
  def calculate(input:, width:, height: )
    digits = input.chomp.chars.map(&:to_i)
    pixels_per_layer = width * height
    layers = digits.each_slice(pixels_per_layer).to_a
    layer_with_fewest_zeros = layers.sort_by do |layer|
      layer.count(0)
    end.first
    layer_with_fewest_zeros.count(1) * layer_with_fewest_zeros.count(2)
  end

  def calculate_b(input:, width:, height: )
    digits = input.chomp.chars.map(&:to_i)
    pixels_per_layer = width * height
    layers = digits.each_slice(pixels_per_layer).to_a




    # result_layer = layer.first

    result_layer = []

    pixels_per_layer.times do |index|
      pixels_in_this_position = layers.map{|layer| layer[index]}

      puts pixels_in_this_position.inspect

      pixels_in_this_position.each do |pixel|
        if pixel == 0 || pixel == 1
          result_layer[index] = pixel
          break
        end
      end

      result_layer[index] ||= 2
    end





    result_layer.each_slice(width).to_a
  end

end


if !ARGV.include?("run")
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    include Something
    def test_calculate
      assert_equal(9, calculate(input: "023456789012111222", width: 3, height: 2))

      assert_equal([[0,1], [1,0]], calculate_b(input: "0222112222120000", width: 2, height: 2))
    end
  end

else
  include Something

  input = File.read('08_input')

  puts calculate(input: input, width: 25, height: 6)

  b_result = calculate_b(input: input, width: 25, height: 6)
  for line in b_result
    puts line.join("").gsub("0", " ")
  end
end
