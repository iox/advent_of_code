class Solution2019
  def initialize
    @test = false
    @input = []
    @input_lines = 0
    @answer = nil
  end

  def run!(test = false)
    @test = test
    read_input
    additional_setup
    process_input
    show_answer
  end

  private

  def additional_setup; end

  def show_answer
    puts "Input Lines: #{@input_lines}"
    puts "The answer is: #{@answer}"
  end

  def read_input
    if @test
      file_to_input 'test-input.txt'
    else
      file_to_input 'input.txt'
    end
  end

  def file_to_input(file)
    File.open(file, 'r') do |f|
      f.each_line do |line|
        @input << line.chomp
        @input_lines += 1
      end
    end
  end
end