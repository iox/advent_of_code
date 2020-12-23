#! /usr/bin/env ruby
require 'set'




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



def parse_input(data)
  grouped_strs = data.split("\n\n").map{|block| block.split("\n")}

  rules = {}

  grouped_strs[0].each do |rule|
    rule_num, rest = rule.split(": ", 2)
    rule_num = rule_num.to_i

    if rest.include?('"')
      rules[rule_num] = [[rest[1]]]
    else
      one_of_parts = rest.split(" | ")
      rules[rule_num] = one_of_parts.map do |part|
        part.split(" ").map(&:to_i)
      end
    end
  end

  messages = Set.new(grouped_strs[1])

  return [rules, messages]
end







def squish(rules)
  res = []

  rules.each do |part|
    if res.last.is_a?(String) && part.is_a?(String)
      res[-1] = res[-1] + part
    else
      res << part
    end
  end

  res
end




def expand(pattern:, rules:, prefixes:, messages:, longest_message:)
  pattern = squish(pattern)

  if pattern[0].is_a?(String)
    if !prefixes.include?(pattern[0])
      return []
    end
  end

  if $cache.key?(pattern)
    return $cache[pattern]
  end
  

  i = 0
  while i < pattern.length && !pattern[i].is_a?(Integer)
    i += 1
  end

  if i == pattern.length
    ret =  [pattern.join("")]
    $cache[pattern] = ret

    if messages.include?(ret[0])
      $num_found += 1
    end

    return ret
  end

  # i is index of first non-terminal
  before = i == 0 ? [] : pattern[0..(i - 1)]
  after = pattern[(i + 1)..]

  all = []
  rules[pattern[i]].each do |expanded|
    pattern =  (before + expanded + after)
    expanded = expand(pattern: pattern, rules: rules, prefixes: prefixes, messages: messages, longest_message: longest_message)
    squished = squish(expanded)
    all.concat(squished)
  end

  $cache[pattern] = all

  all
end




def prepare_prefixes(messages)
  prefixes = Set.new
  messages.each do |str|
    str.length.times do |i|
      prefixes << str[0..i]
    end
  end
  prefixes
end











def part1(data)
  rules, messages = parse_input(data)
  longest_message = messages.to_a.map(&:length).max
  prefixes = prepare_prefixes(messages)
  
  $cache = {}
  $num_found = 0
  
  expand(pattern: [0], prefixes: prefixes, rules: rules, messages: messages, longest_message: longest_message)
  $num_found
end



def part2(data)
  rules, messages = parse_input(data)
  longest_message = messages.to_a.map(&:length).max
  prefixes = prepare_prefixes(messages)

  rules[8] = [[42], [42, 8]]
  rules[11] = [[42, 31], [42, 11, 31]]

  $cache = {}
  $num_found = 0

  expand(pattern: [0], prefixes: prefixes, rules: rules, messages: messages, longest_message: longest_message)
  $num_found
end










part2(example_part2)






if ARGV.include?('test')
  require 'test/unit'

  class SomethingTest < Test::Unit::TestCase
    def test_part2
      assert_equal(12, part2(example_part2))
    end
  end
else

  data = File.read('19_input')
  puts "Part 1: #{part1(data)}"
  puts "Part 2: #{part2(data)}"

end