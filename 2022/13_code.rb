def compare(a,b)
  # puts "  - Compare #{a} vs #{b}"
  if a.is_a?(Integer) && b.is_a?(Integer)
    if a < b
      return true
    elsif a > b
      return false
    elsif a == b
      return "next"
    end
    raise "error"
  end


  if a.is_a?(Array) && b.is_a?(Array)
    a.each.with_index do |sub_a, sub_i|
      sub_b = b[sub_i]
      if sub_b.nil?
        return false
      end

      result = compare(sub_a,sub_b)
      next if result == "next"
      return result
    end

    if b.size > a.size
      return true
    end

    return "next"

  end


  if a.is_a?(Integer)
    a = [a]
    return compare(a,b)
  end

  if b.is_a?(Integer)
    b = [b]
    return compare(a,b)
  end

  raise "WHAT? #{a.class} && #{b.class}"
end













pairs = File.read('13_example').split("\n\n")


indexes = []
pairs.each.with_index do |pair, i|
  a = eval(pair.split("\n")[0])
  b = eval(pair.split("\n")[1])
  result = compare(a,b)
  indexes << i+1 if result
end

puts indexes.reduce(:+)












# Part 2
packets = File.read('13_input').split("\n\n").map{|pair| pair.split("\n")}.flatten
packets << "[[2]]"
packets << "[[6]]"
# puts packets.join("\n")

puts "\n\n"
sorted = packets.sort do |a,b|
  comparison = compare(eval(a),eval(b))
  comparison ? -1 : 1
end

# puts sorted.join("\n")
puts "\n\n----"
puts (sorted.index("[[2]]")+1) * (sorted.index("[[6]]")+1)