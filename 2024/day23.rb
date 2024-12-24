require 'json'

def parse_input(input)
  groups_of_two = input.split("\n").map(&:strip)

  connections = Hash.new { |hash, key| hash[key] = [] }

  groups_of_two.each do |group|
    a,b = group.split("-")

    connections[a] << b
    connections[b] << a
  end
  connections
end


def find_connected_pcs(input)
  connections = parse_input(input)
  candidates = []
  connections.each do |k, subgroup|
    subgroup.combination(2).to_a.each do |combo|
      a,b = combo
      if connections[a].include?(b)
        candidates << [a,b,k].sort
      end
    end
  end
  candidates.uniq
end


def part1(input)
  find_connected_pcs(input).count do |group|
    group.any?{|pc| pc.start_with?("t")}
  end
end

def part2(input)
  connections = parse_input(input)
  results = Hash.new { |hash, key| hash[key] = [] }
  connections.each do |k, subgroup|
    candidates = [k]
    (2..subgroup.size).to_a.reverse.each do |combination_size|
      subgroup.combination(combination_size).to_a.each do |combo|
        if all_connected(combo, connections)
          sorted_combo = ([k]+combo).sort
          # puts "Found that #{sorted_combo} are all connected together"
          results[combo.size] << sorted_combo
        end
      end
    end
  end
  results[results.keys.max].first.join(",")

end


def all_connected(group, connections)
  group.combination(2).all? do |combo|
    a,b = combo
    connections[a].include?(b)
  end
end


# puts part1(File.read("day23.txt"))
puts part2(File.read("day23.txt"))



require 'minitest/autorun'
require 'minitest/color'

class TestDay3 < Minitest::Test
  def sample
    <<-EOF
    kh-tc
    qp-kh
    de-cg
    ka-co
    yn-aq
    qp-ub
    cg-tb
    vc-aq
    tb-ka
    wh-tc
    yn-cg
    kh-ub
    ta-co
    de-co
    tc-td
    tb-wq
    wh-td
    ta-ka
    td-qp
    aq-cg
    wq-ub
    ub-vc
    de-ta
    wq-aq
    wq-vc
    wh-yn
    ka-de
    kh-ta
    co-tc
    wh-qp
    tb-vc
    td-yn
    EOF
  end

  def sample_connected_pcs
    list = <<-EOF
    aq,cg,yn
    aq,vc,wq
    co,de,ka
    co,de,ta
    co,ka,ta
    de,ka,ta
    kh,qp,ub
    qp,td,wh
    tb,vc,wq
    tc,td,wh
    td,wh,yn
    ub,vc,wq
    EOF
    list.split("\n").map(&:strip).map{|group| group.split(",").sort}
  end

  def test_part1
    sample_connected_pcs.each do |group|
      assert_includes find_connected_pcs(sample), group
    end
    assert_equal 7, part1(sample)
  end

  def test_part2
    assert_equal "co,de,ka,ta", part2(sample)
  end
end