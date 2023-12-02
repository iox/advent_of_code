# Every snailfish number is an array of 2 elements

# Each element in the pair is an integer, of another array of 2 elements

# Summing them is easy. Just wrap them in a new array with 2 elements [a, b]

# After summing, the resulting number needs to be "reduced" using a loop
  # If there are too many sublevels, there is an explosion
  # If any regular number is 10 or more, the number splits

def sum(a, b)
  result = [a,b]
  # puts "after addition:   #{result.inspect.delete(' ')}"

  # count = 0
  loop do
    # Try exploding
    old_result_string = result.inspect 
    explode(result)
    if old_result_string != result.inspect
      # count += 1
      # puts "\n\nCount: #{count}"
      # puts result.first.inspect
      # puts result.last.inspect
      next
    end

    # Try splitting
    old_result_string = result.inspect
    split(result)
    if old_result_string != result.inspect
      # count += 1
      # puts "\n\ncount: #{count}"
      # # puts "    " + old_result_string
      # puts result.first.inspect
      # puts result.last.inspect
      next
    end

    break
  end



  result
end




def explode(n)
  # puts "input:"
  # puts n.inspect

  exploded = false

  # Find the first pair nested inside four pairs
  n.each_with_index do |child0, i0|
    break if exploded
    if child0.is_a?(Array)
      # puts "--#{child0.inspect}"
      child0.each_with_index do |child1, i1|
        break if exploded
        # puts "----#{child1.inspect}"
        if child1.is_a?(Array)
          child1.each_with_index do |child2, i2|
            break if exploded
            # puts "------#{child2.inspect}"
            if child2.is_a?(Array)
              child2.each_with_index do |child3, i3|
                break if exploded
                # puts "--------#{child3.inspect}"
                if child3.is_a?(Array)
                  # puts "i0 #{i0}   i1 #{i1}   i2 #{i2}   i3 #{i3}"

                  # ----------
                  # RIGHT SIDE: find next item to add the left value
                  # ----------
                  target = nil
                  if i3 == 0
                    target = n[i0][i1][i2][1]
                    n[i0][i1][i2][1] += child3[1] if target.is_a?(Integer)
                  elsif i2 == 0
                    target = n[i0][i1][1]
                    n[i0][i1][1] += child3[1] if target.is_a?(Integer)
                  elsif i1 == 0
                    target = n[i0][1]
                    n[i0][1] += child3[1] if target.is_a?(Integer)
                  elsif i0 == 0
                    target = n[1]
                    n[1] += child3[1] if target.is_a?(Integer)
                  end
                  if target && target.is_a?(Array)
                    # Fun stuff: if you get to the integer, you can not use pointers any more!!!
                    target = target[0] while target[0].is_a?(Array)
                    target[0] += child3[1]
                  end





                  # ----------
                  # LEFT SIDE: find next item to add the right value
                  # ----------
                  target = nil
                  if i3 == 1
                    target = n[i0][i1][i2][0]
                    n[i0][i1][i2][0] += child3[0] if target.is_a?(Integer)
                  elsif i2 == 1
                    target = n[i0][i1][0]
                    n[i0][i1][0] += child3[0] if target.is_a?(Integer)
                  elsif i1 == 1
                    target = n[i0][0]
                    n[i0][0] += child3[0] if target.is_a?(Integer)
                  elsif i0 == 1
                    target = n[0]
                    n[0] += child3[0] if target.is_a?(Integer)
                  end
                  if target && target.is_a?(Array)
                    target = target[1] while target[1].is_a?(Array)
                    target[1] += child3[0]
                  end




                  # Set this pair to 0
                  n[i0][i1][i2][i3] = 0


                  # We only do the exploding once and stop
                  exploded = true
                end
              end
            end
          end
        end
      end
    end
  end


  


  # puts "output:"
  # puts n.inspect
  return n
end

def split_integer(n)
  a = (n / 2.to_f).floor
  b = (n / 2.to_f).ceil
  [a,b]
end

def split(n)
  splitted = false
  n.each_with_index do |child0, i0|
    break if splitted
    if child0.is_a?(Integer) && child0 > 9
      n[i0] = split_integer(child0)
      splitted = true
    end
    if child0.is_a?(Array)
      child0.each_with_index do |child1, i1|
        break if splitted
        if child1.is_a?(Integer) && child1 > 9
          n[i0][i1] = split_integer(child1)
          splitted = true
        end
        if child1.is_a?(Array)
          child1.each_with_index do |child2, i2|
            break if splitted
            if child2.is_a?(Integer) && child2 > 9
              n[i0][i1][i2] = split_integer(child2)
              splitted = true
            end
            if child2.is_a?(Array)
              child2.each_with_index do |child3, i3|
                break if splitted
                if child3.is_a?(Integer) && child3 > 9
                  n[i0][i1][i2][i3] = split_integer(child3)
                  splitted = true
                end
                if child3.is_a?(Array)
                  child3.each_with_index do |child4,i4|
                    break if splitted
                    if child4.is_a?(Integer) && child4 > 9
                      n[i0][i1][i2][i3][i4] = split_integer(child4)
                      splitted = true
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  n
end



def magnitude(n)
  # puts "magnitude was called! #{n}"
  left,right = n

  if left.is_a?(Array)

    left = magnitude(left)
  end
  if right.is_a?(Array)
    right = magnitude(right)
  end

  raise "#{left.inspect}" if left.is_a?(Array)
  raise "#{right.inspect}" if right.is_a?(Array)

  result = left * 3 + right * 2
  # puts "magnitude(#{n}) is returning #{result}"
  return result
end
  





# Single explode reduction examples
raise "HEY" unless explode([[[[[9,8],1],2],3],4]) == [[[[0,9],2],3],4]
raise "HEY" unless explode([7,[6,[5,[4,[3,2]]]]]) == [7,[6,[5,[7,0]]]]
raise "HEY" unless explode([[6,[5,[4,[3,2]]]],1]) == [[6,[5,[7,0]]],3]
raise "HEY" unless explode([[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]) == [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]
raise "HEY" unless explode([[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]) == [[3,[2,[8,0]]],[9,[5,[7,0]]]]


# Split examples
raise "HEY" unless split_integer(10) == [5,5]
raise "HEY" unless split_integer(11) == [5,6]
raise "HEY" unless split_integer(12) == [6,6]
raise "HEY" unless split([[1,2],[[3,4],12]]) == ([[1,2],[[3,4],[6,6]]])
raise "HEY" unless split([[1,2],[12,12]]) == ([[1,2],[[6,6],12]])
raise "HEY" unless split([[[9, 10], 20], [8, [9, 0]]]) == [[[9, [5, 5]], 20], [8, [9, 0]]]



# Simple sum, no reducing needed
raise "HEY" unless sum([1,2] , [[3,4],5]) == [[1,2],[[3,4],5]]

# First scary sum
raise "HEY" unless sum([[[[4,3],4],4],[7,[[8,4],9]]] , [1,1]) == [[[[0,7],4],[[7,8],[6,0]]],[8,1]]


# Multiple sums
raise "HEY" unless [[1,1],[2,2],[3,3],[4,4]].reduce{|sum, n| sum(sum, n)} == [[[[1,1],[2,2]],[3,3]],[4,4]]
raise "HEY" unless [[1,1],[2,2],[3,3],[4,4],[5,5]].reduce{|sum, n| sum(sum, n)} == [[[[3,0],[5,3]],[4,4]],[5,5]]
raise "HEY" unless [[1,1],[2,2],[3,3],[4,4],[5,5],[6,6]].reduce{|sum, n| sum(sum, n)} == [[[[5,0],[7,4]],[5,5]],[6,6]]


# Super scary example
super_scary_example = [
  [[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]],
  [7,[[[3,7],[4,3]],[[6,3],[8,8]]]],
  [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]],
  [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]],
  [7,[5,[[3,8],[1,4]]]],
  [[2,[2,2]],[8,[8,1]]],
  [2,9],
  [1,[[[9,3],9],[[9,0],[0,7]]]],
  [[[5,[7,4]],7],1],
  [[[[4,2],2],6],[8,7]]
]

raise "HEY" unless super_scary_example.reduce{|sum, n| sum(sum, n)}.inspect.delete(" ") == "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]"




another_scary_example = [
  [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]],
  [[[5,[2,8]],4],[5,[[9,9],0]]],
  [6,[[[6,2],[5,6]],[[7,6],[4,7]]]],
  [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]],
  [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]],
  [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]],
  [[[[5,4],[7,7]],8],[[8,3],8]],
  [[9,3],[[9,9],[6,[4,9]]]],
  [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]],
  [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
]
raise "HEY" unless another_scary_example.reduce{|sum, n| sum(sum, n)}.inspect.delete(" ") == "[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]"



raise "HEY" unless magnitude([9,1]) == 29
raise "HEY" unless magnitude([1,9]) == 21
raise "HEY" unless magnitude([[9,1],[1,9]]) == 129
raise "HEY" unless magnitude([[1,2],[[3,4],5]]) == 143
raise "HEY" unless magnitude([[[[0,7],4],[[7,8],[6,0]]],[8,1]]) == 1384
raise "HEY" unless magnitude([[[[1,1],[2,2]],[3,3]],[4,4]]) == 445
raise "HEY" unless magnitude([[[[3,0],[5,3]],[4,4]],[5,5]]) == 791
raise "HEY" unless magnitude([[[[5,0],[7,4]],[5,5]],[6,6]]) == 1137
raise "HEY" unless magnitude([[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]) == 3488
raise "HEY" unless magnitude([[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]) == 4140



my_data = File.readlines('18_input').map{|l| eval(l)}
puts magnitude(my_data.reduce{|sum, n| sum(sum, n)})


my_data_2 = File.readlines('18_input').map{|l| eval(l)}
data = my_data_2.permutation(2).map do |(a, b)|
  tempa = Marshal.load(Marshal.dump(a))
  tempb = Marshal.load(Marshal.dump(b))
  magnitude(sum(tempa,tempb))
end
puts data.max

puts "OK"
