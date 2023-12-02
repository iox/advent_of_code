
def decode_bits(bits)
  packet_version = bits[0,3].to_i(2)
  packet_type_id = bits[3,3].to_i(2)

  # puts "packet_version: #{packet_version}"
  @version_numbers << packet_version
  puts "packet_type_id: #{packet_type_id}"

  value = 0
  index = 6


  # Represents a literal value
  if packet_type_id == 4
    groups = bits[index..].scan(/...../)
    # puts groups.inspect

    number_bits = ""
    groups.each do |group|
      index += 5
      number_bits += group[1..]
      # This means that this packet is finished!
      break if group.chars.first == "0"
    end

    puts "\n>>>>> The number is #{number_bits.to_i(2)}\n\n"
    value = number_bits.to_i(2)

  # Every other type of packet represents an operator
  else
    # Operators consist of multiple subpackets. Each subpacket will have a value
    values = []


    length_type_id = bits[index,1]
    index += 1

    if length_type_id == "0"
      # next 15 bits are a number that represents the total length in bits of the sub-packets contained by this packet.
      subpackets_total_length = bits[index,15].to_i(2)
      index += 15
      puts "subpackets_total_length #{subpackets_total_length}"

      while subpackets_total_length > 0
        rest = bits[index,subpackets_total_length]
        value, subindex = decode_bits(rest)
        values << value
        
        subpackets_total_length -= subindex
        index += subindex
      end

    else
      # next 11 bits are a number that represents the number of sub-packets immediately contained by this packet
      contained_subpackets_number = bits[index,11].to_i(2)
      index += 11

      
      while contained_subpackets_number > 0
        rest = bits[index..]
        puts "contained_subpackets_number #{contained_subpackets_number}"
        if rest && rest.size > 10
          # puts "There are some leftover. Maybe there is another packet next. Calling decode_bits with #{rest}"
          value, subindex = decode_bits(rest)
          index += subindex
          values << value
        end
        contained_subpackets_number -= 1
      end

      # TODO: We are not limiting the number of subpackets parsing at all...
      # In fact, we are not doing anything with this operator except for increasing the index...
    end
  
    if packet_type_id == 0
      value = values.sum
    elsif packet_type_id == 1
      value = values.reduce(:*)
    elsif packet_type_id == 2
      value = values.min
    elsif packet_type_id == 3
      value = values.max
    elsif packet_type_id == 5
      value = values[0] > values[1] ? 1 : 0
    elsif packet_type_id == 6
      value = values[0] < values[1] ? 1 : 0
    elsif packet_type_id == 7
      value = values[0] == values[1] ? 1 : 0
    else
      puts "packet_type_id #{packet_type_id} not implementing, defaulting to sum #{values.join(' + ')} = #{values.sum}"
      value = values.sum
    end
  end

  # Decode bits receives a bit string, and returns 2 things, a value and the number of used bits (index)
  return value, index

end





def decode(string, part2: false)
  puts "\n\nDecoding #{string}\n---------------------------"

  @version_numbers = []

  # Convert to a string og bits
  bits = string.chars.map do |char|
    char.to_i(16).to_s(2).rjust(4,"0")
  end.join

  value, _ = decode_bits(bits)

  if part2
    return value
  else
    puts "Version numbers: #{@version_numbers.inspect} . Sum: #{@version_numbers.sum}"
    return @version_numbers
  end
end






decode("D2FE28")
decode("38006F45291200")
decode("EE00D40C823060")
raise "HEY" if decode("8A004A801A8002F478").sum != 16
raise "HEY" if decode("620080001611562C8802118E34").sum != 12
raise "HEY" if decode("C0015000016115A2E0802F182340").sum != 23
raise "HEY" if decode("A0016C880162017C3686B18A3D4780").sum != 31
puts decode(File.read('16_input')).sum
puts "OK"









def calculate(string)
  decode(string, part2: true)
end


raise "HEY" if calculate("C200B40A82") != 3
raise "HEY" if calculate("04005AC33890") != 54
raise "HEY" if calculate("880086C3E88112") != 7
raise "HEY" if calculate("CE00C43D881120") != 9
raise "HEY" if calculate("D8005AC2A8F0") != 1
raise "HEY" if calculate("F600BC2D8F") != 0
raise "HEY" if calculate("9C005AC2F8F0") != 0
raise "HEY" if calculate("9C0141080250320F1802104A08") != 1

puts calculate(File.read('16_input'))
puts "OK"
