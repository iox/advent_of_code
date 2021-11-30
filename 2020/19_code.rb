


def even_simpler_example
<<-EXAMPLE
0: 1 2
1: "a"
2: "b"

ab
EXAMPLE
end



def example_data_simple
<<-EXAMPLE
0: 1 2
1: "a"
2: 1 3 | 3 1
3: "b"

aab
aba
aaa
bbb
baba
EXAMPLE
end


def example_data
<<-EXAMPLE
0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"

ababbb
bababa
abbbab
aaabbb
aaaabbb
EXAMPLE
end
  
  
def example_part2
<<-EXAMPLE
42: 9 14 | 10 1
9: 14 27 | 1 26
10: 23 14 | 28 1
1: "a"
11: 42 31
5: 1 14 | 15 1
19: 14 1 | 14 14
12: 24 14 | 19 1
16: 15 1 | 14 14
31: 14 17 | 1 13
6: 14 14 | 1 14
2: 1 24 | 14 4
0: 8 11
13: 14 3 | 1 12
15: 1 | 14
17: 14 2 | 1 7
23: 25 1 | 22 14
28: 16 1
4: 1 1
20: 14 14 | 1 15
3: 5 14 | 16 1
27: 1 6 | 14 18
14: "b"
21: 14 1 | 1 14
25: 1 1 | 1 14
22: 14 14
8: 42
26: 14 22 | 1 20
18: 15 15
7: 14 5 | 1 21
24: 14 1

abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
bbabbbbaabaabba
babbbbaabbbbbabbbbbbaabaaabaaa
aaabbbbbbaaaabaababaabababbabaaabbababababaaa
bbbbbbbaaaabbbbaaabbabaaa
bbbababbbbaaaaaaaabbababaaababaabab
ababaaaaaabaaab
ababaaaaabbbaba
baabbaaaabbaaaababbaababb
abbbbabbbbaaaababbbbbbaaaababb
aaaaabbaabaaaaababaa
aaaabbaaaabbaaa
aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
babaaabbbaaabaababbaabababaaab
aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
EXAMPLE
end

  




class Rule
  attr_reader :paths

  def initialize(paths) # [Path.new([1,2])]
    @paths = paths
  end
end


class Path
  attr_reader :subrules # [1,2,3]

  def initialize(subrules)
    @subrules = subrules
  end
end



def parse_rules(data)
  rules = {}
  data.split("\n\n")[0].split("\n").each do |line|
    key = line.split(": ")[0].to_i
    
    paths = line.split(": ")[1].split("|").map do |group|
      subrules = group.split(" ").map do |char|
        char.match(/a|b/) ? char.gsub("\"", '') : char.to_i
      end
      Path.new(subrules)
    end

    rules[key] = Rule.new(paths)
  end
  rules
end

def parse_messages(data)
  data.split("\n\n")[1].split("\n")
end








def calculate_length(rules, index)
  length = 0
  path = rules[index].paths.first
  if path.subrules.first == "a" || path.subrules.first == "b"
    length += 1
  else
    path.subrules.each do |subrule_index|
      length += calculate_length(rules, subrule_index)
    end
  end
  return length
end


def part1(data)
  rules = parse_rules(data)
  messages = parse_messages(data)
  valid_length = calculate_length(rules, 0)

  valid_length_messages = messages.select do |message|
    message.size == valid_length
  end

  rule = rules[0]
  valid_length_messages.select do |message|
    is_valid?(rules, rule, message)
  end
end







def is_valid?(rules, rule, message)
  puts "Checking validity of #{message}"
  rule.paths.any? do |path|
    message_start = 0
    path.subrules.all? do |subrule_index|
      if subrule_index == "a" || subrule_index == "b"
        return message == subrule_index
      end
      subrule = rules[subrule_index]
      length = calculate_length(rules, subrule_index)
      submessage = message[message_start, length]
      message_start += length
      is_valid = is_valid?(rules, subrule, submessage)

      puts " >> submessage '#{submessage}' was #{is_valid.to_s} according to rule #{subrule_index}"
      is_valid
    end
  end
end


































def part2(data)
  $cache = {}
  $rules = parse_rules(data)
  $rules[8] = Rule.new([Path.new([42]), Path.new([42,8])])
  $rules[11] = Rule.new([Path.new([42,31]), Path.new([42,11,31])])
  $target_messages = parse_messages(data)
  $max_length = $target_messages.map(&:size).max

  $counter = 0

  all_possible_messages =  recursive_part2(0, "")

  puts "Found #{all_possible_messages.size} possible messages"
  # puts all_possible_messages.inspect

  # puts "$cache"
  # puts $cache.inspect


  result_messages = $target_messages.select do |target_message|
    all_possible_messages.include?(target_message)
  end

  # puts "\n\n\n Result messages: #{result_messages.size}\n\n\n"
  # puts result_messages.inspect

  result_messages.size
end





def recursive_part2(rule_index, message, depth=0)
  if $cache[rule_index]
    return $cache[rule_index]
  end


  if message.size > $max_length
    puts "Arrived to max length #{$max_length}, stopping here"
    return []
  end
  # if $target_messages.none?{ |target_message| target_message.start_with?(message) } 
  #   puts "  #{'  '*depth}The message '#{message}' does not match any of the #{$target_messages.size} target messages, RETURNING FROM THIS LOOP"
  #   return []
  # end

  $counter += 1
  # puts "Counter #{$counter}, message size #{message.size}          (#{message})" if $counter % 1000 == 0
  limit = 10000

  if $counter > limit
    puts "\n\nYOU CAN DO THIS!\n\n"
    return [] 
  end

  message_results = []


  rule = $rules[rule_index]
  loop_code = ('A'..'Z').to_a.shuffle[0,3].join
  puts "\n\n#{'  '*depth}Loop #{loop_code} #{$counter}/#{limit} with message #{message}.  We found a new rule! Rule #{rule_index} has #{rule.paths.size} paths"
  rule.paths.each_with_index do |path, path_index|
    messages_for_this_path = []
    path_code = ('A'..'Z').to_a.shuffle[0,3].join
    # puts "  #{'  '*depth}Path #{path_code} #{path_index} has #{path.subrules.size} subrules: #{path.subrules.inspect}. Current messages: #{messages_for_this_path}"
    path.subrules.each_with_index do |subrule_index, i|
      # puts "    #{'  '*depth}Path #{path_code}  Processing subrule #{i+1}/#{path.subrules.size}, with the value #{rule_index}"

      # We need the cartesian product of the results of the subrules
      # ["aba"].product(["aba","baba"]).map(&:join)
      # => ["abaaba", "abababa"]

      if subrule_index == "a" || subrule_index == "b"
        messages_for_this_path += [subrule_index]
        # $possible_messages << message_for_this_path
        # puts "  #{'  '*depth}<<< We found a letter! Adding '#{subrule_index}' to messages #{messages_for_this_path} >>>"
      else
        recursive_results = recursive_part2(subrule_index, message+messages_for_this_path.last.to_s, depth+2)
        # puts "recursive_results: #{recursive_results.inspect}"
        if recursive_results.size > 0
          if messages_for_this_path.size > 0 && (message.size+messages_for_this_path.last.size+recursive_results.last.size < $max_length)
            puts "$max_length #{$max_length}   message.size #{message.size}  messages_for_this_path.last.size #{messages_for_this_path.last.size}  recursive_results.last.size #{recursive_results.last.size}"
            puts "Cartesian product: #{messages_for_this_path.size} * #{recursive_results.size}"
            messages_for_this_path = messages_for_this_path.product(recursive_results).map(&:join).uniq
          else
            messages_for_this_path = recursive_results
          end
          
          # puts "messages_for_this_path: #{messages_for_this_path.inspect}"
        end
      end
    end

    # puts "    #{'  '*depth}Path #{path_code}. At the end of the path, messages_for_this_path has the value #{messages_for_this_path}\n\n"


    
    message_results = (message_results + messages_for_this_path).uniq
  end

  

  # if rule_index != 8 && rule_index != 11
    puts "#{'  '*depth}<< Filling cache for rule #{rule_index}. End of Loop #{loop_code}.\n\n"
    $cache[rule_index] = message_results.uniq
    
    $cache[rule_index]
  # else
  #   message_results.uniq
  # end



end







if ARGV.include?('test')
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    # def test_part1
    #   assert_equal(["ab"], part1(even_simpler_example))
    #   assert_equal(["aab", "aba"], part1(example_data_simple))
    #   assert_equal(["ababbb", "abbbab"], part1(example_data))
    # end

    def prepare_recursive_result(rule)
      $cache = {}
      $rules = parse_rules(example_part2)
      $rules[0] = rule
      $rules[1111] = Rule.new([
        Path.new([1,14]), Path.new([14,1])
      ])
      $target_messages = parse_messages(example_part2)
      $max_length = $target_messages.map(&:size).max
      $counter = 0
      recursive_part2(0, '')
    end

    def test_recursive_part2
      assert_equal(["ab"], prepare_recursive_result(Rule.new([
        Path.new([1,14])
      ])))


      assert_equal(["aba"], prepare_recursive_result(Rule.new([
        Path.new([1,14,1])
      ])))

      assert_equal(["ab", "ba"], prepare_recursive_result(Rule.new([
        Path.new([1,14]), Path.new([14,1])
      ])))

      assert_equal(["ab", "bab", "bba"], prepare_recursive_result(Rule.new([
        Path.new([1,14]), Path.new([14,1111])
      ])))

      # assert_equal(["aa", "aaa"], prepare_recursive_result(Rule.new([
      #   Path.new([1,0]), Path.new([1])
      # ])))
    end

    # def test_part2
    #   assert_equal(12, part2(example_part2))
    # end


  end
end


# data = File.read("19_input")

# puts "Part 1 #{part1(data).size}"


# puts "Part 2: #{part2(data)}"
puts part2(example_part2)






