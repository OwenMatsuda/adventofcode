def calibrate(input)
  input.split("\n")
       .map { |line| line[/\d{1}/] + line.match(/.*(\d{1})/).captures[0] }
       .map(&:to_i)
       .sum
end

input = File.read('./input.txt')

# puts calibrate(input)

NUMBERS = /one|two|three|four|five|six|seven|eight|nine/

def calibrate_2(input)
  input.split("\n")
       .map { |line| to_num(line[/\d{1}|#{NUMBERS}/]) + to_num(line.match(/.*(\d{1}|#{NUMBERS})/).captures[0]) }
       .map(&:to_i)
       .sum
end

def to_num(num)
  number_map = { 'one': '1', 'two': '2', 'three': '3', 'four': '4', 'five': '5', 'six': '6', 'seven': '7', 'eight': '8',
                 'nine': '9' }

  number_map.key?(num.to_sym) ? number_map[num.to_sym] : num
end

test_input = "two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen"

puts calibrate_2(input)
