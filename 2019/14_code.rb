#! /usr/bin/env ruby

module Something
  def calculate(input)
    @reactions = extract_data(input)

    counter = 0
    @leftovers = Hash.new(0)
    @ore_counter = 0
    
    get_ore(target_material: 'FUEL', target_amount: 1, depth: 0)
    @ore_counter
  end


  def calculate_b(input)
    @reactions = extract_data(input)
    available_ore = 1000000000000

    counter = 0
    @leftovers = Hash.new(0)
    @ore_counter = 0
    
    @fuel_amount = 0



    # get_ore(target_material: 'FUEL', target_amount: 82892753, depth: 0)

    loop do
      if @fuel_amount % 1000 == 0
        percentage = @ore_counter.to_f / available_ore * 100
        puts "Ore counter: #{@ore_counter} (#{percentage.round(2)}% of the trillion), fuel amount: #{@fuel_amount}"
      end

      get_ore(target_material: 'FUEL', target_amount: 3848998, depth: 0)
      break if @ore_counter > available_ore
      @fuel_amount += 1
    end
    @fuel_amount
  end


  # This method prepares the requested material, and fills @ore_counter and @leftovers instance variables
  def get_ore(target_material:, target_amount:, depth:)
    padding = "    " * depth
    # puts "\n\n#{padding}GET_ORE: We need #{target_amount} of #{target_material}"

    # If we are asked for ORE, just count it and stop
    if target_material == 'ORE'
      @ore_counter += target_amount
      # puts "#{padding}BRANCH END: just added #{target_amount} to the ore counter"
      return
    end

    # If we have enough leftovers, use them and stop
    if @leftovers[target_material] >= target_amount
      @leftovers[target_material] -= target_amount
      # puts "#{padding}BRANCH END: we found the material in @leftovers. This is what is left: #{@leftovers.inspect}"
      return
    end

    # If we have some leftovers, use them to reduce the target_amount
    if @leftovers[target_material] > 0
      # puts "#{padding}  - LUCKY US: We can reduce our target amount #{target_amount} to #{target_amount - @leftovers[target_material]}, because we had #{@leftovers[target_material]} leftovers"
      target_amount -= @leftovers[target_material]
      @leftovers[target_material] = 0
    end




    # OK, so it's not ORE and we don't have enough leftovers. We need to produce them

    # 1) Find an appropriate chemical reaction: it will contain multiple sources, and a result amount
    reaction = @reactions.select {|k, _| k.include? target_material}
    sources = reaction.values[0]
    single_reaction_result_amount = reaction.keys[0].split(' ')[0].to_i
    # puts "#{padding}  - We have found a chemical reaction to produce #{target_material}. You use #{sources} and you get #{single_reaction_result_amount} #{target_material}"



    # 2) How many times to we need to run this reaction?
    number_of_reactions_needed = (target_amount.to_i.to_f / single_reaction_result_amount.to_i.to_f).ceil
    # puts "#{padding}  - We need to run the reaction #{number_of_reactions_needed} times, because each reaction produces #{single_reaction_result_amount} and we need #{target_amount}"
    

    # 3) Store the leftovers
    produced_material_amount = number_of_reactions_needed * single_reaction_result_amount
    leftover = produced_material_amount - target_amount
    if leftover > 0
      @leftovers[target_material] += leftover
      # puts "#{padding}  - We have stored #{leftover} of #{target_material} in @leftovers: #{@leftovers}"
    end


    # 4) Run the subreactions
    depth += 1
    # number_of_reactions_needed.times do |index|
    #   # puts "\n#{padding}  > Running reaction #{index+1}/#{number_of_reactions_needed}"
    #   # puts "#{padding}  ――――――――――――――――――――――"
    #   sources.each do |source|
    #     source_amount = source.split(" ")[0].to_i
    #     source_material = source.split(" ")[1]

        
    #     get_ore(target_material: source_material, target_amount: source_amount, depth: depth)

    #     # DEBUGGING THE CONSUMPTION
    #     # puts "\n\n\n\n"
    #     # if source_material == 'ORE'
    #     #   @debug_consumption[target_material][:ore_amount] += source_amount
    #     #   @debug_consumption[target_material][:produced_amount] += single_reaction_result_amount
    #     # end
    #   end
    # end



    # 4 OPTIMIZED) Run the reactions
    sources.each do |source|
      source_amount = source.split(" ")[0].to_i * number_of_reactions_needed
      source_material = source.split(" ")[1]      
      get_ore(target_material: source_material, target_amount: source_amount, depth: depth)
    end
  end


  def extract_data(input)
    # {'1 FUEL' => ['7 A', '1 E']}
    data = {}
    input.split("\n").each do |reaction|
      reaction.strip!
      result = reaction.split(" => ")[1]
      sources = reaction.split(" => ")[0].split(', ')
      data[result] = sources
    end
    data
  end

end


if !ARGV.include?("run")
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    include Something


    EXAMPLE_1 = <<-HEREDOC
      10 ORE => 10 A
      1 ORE => 1 B
      7 A, 1 B => 1 C
      7 A, 1 C => 1 D
      7 A, 1 D => 1 E
      7 A, 1 E => 1 FUEL
    HEREDOC
    RESULT_1 = 31

    EXAMPLE_2 = <<-HEREDOC
      9 ORE => 2 A
      8 ORE => 3 B
      7 ORE => 5 C
      3 A, 4 B => 1 AB
      5 B, 7 C => 1 BC
      4 C, 1 A => 1 CA
      2 AB, 3 BC, 4 CA => 1 FUEL
    HEREDOC
    RESULT_2 = 165


    EXAMPLE_3 = <<-HEREDOC
      157 ORE => 5 NZVS
      165 ORE => 6 DCFZ
      44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
      12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
      179 ORE => 7 PSHF
      177 ORE => 5 HKGWZ
      7 DCFZ, 7 PSHF => 2 XJWVT
      165 ORE => 2 GPVTF
      3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT
    HEREDOC
    RESULT_3 = 13312

    EXAMPLE_4 = <<-HEREDOC
      2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG
      17 NVRVD, 3 JNWZP => 8 VPVL
      53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL
      22 VJHF, 37 MNCFX => 5 FWMGM
      139 ORE => 4 NVRVD
      144 ORE => 7 JNWZP
      5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC
      5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV
      145 ORE => 6 MNCFX
      1 NVRVD => 8 CXFTF
      1 VJHF, 6 MNCFX => 4 RFSQX
      176 ORE => 6 VJHF
    HEREDOC
    RESULT_4 = 180697


    EXAMPLE_5 = <<-HEREDOC
      171 ORE => 8 CNZTR
      7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
      114 ORE => 4 BHXH
      14 VRPVC => 6 BMBT
      6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
      6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
      15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
      13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
      5 BMBT => 4 WPTQ
      189 ORE => 9 KTJDG
      1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
      12 VRPVC, 27 CNZTR => 2 XDBXC
      15 KTJDG, 12 BHXH => 5 XCVML
      3 BHXH, 2 VRPVC => 7 MZWV
      121 ORE => 7 VRPVC
      7 XCVML => 6 RJRHP
      5 BHXH, 4 VRPVC => 5 LTCX
    HEREDOC
    RESULT_5 = 2210736



    RESULT_B_3 = 82892753
    RESULT_B_4 = 5586022
    RESULT_B_5 = 460664

    # def test_calculate
    #   assert_equal(RESULT_1, calculate(EXAMPLE_1))
    #   assert_equal(RESULT_2, calculate(EXAMPLE_2))
    #   assert_equal(RESULT_3, calculate(EXAMPLE_3))      
    #   assert_equal(RESULT_4, calculate(EXAMPLE_4))
    #   assert_equal(RESULT_5, calculate(EXAMPLE_5))
    # end

    def test_calculate_b
      # assert_equal(RESULT_B_3, calculate_b(EXAMPLE_3))      
      # assert_equal(RESULT_B_4, calculate_b(EXAMPLE_4))
      assert_equal(RESULT_B_5, calculate_b(EXAMPLE_5))
    end
  end

else
  include Something
  input = File.read('14_input')
  # puts calculate(input)

  puts calculate_b(input)
end
