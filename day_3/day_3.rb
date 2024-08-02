# frozen_string_literal: true

# idea:
#  - transform input into an grid
#  - iterate over grid until we find a symbol
#  - search the 8 values around the symbol to look for a number
#  - if a number is found:
#   - iterate backwards/forwards to complete the number
#   - mark square as viewed

class EngineSchematic
  attr_reader :schematic, :visited

  def initialize(schematic)
    @schematic = to_grid(schematic)
    @visited = Array.new(height) { Array.new(width) }
  end

  def schematic_sum
    sum = 0
    row = 0
    col = 0

    while row < height
      while col < width
        val = @schematic[row][col]
        sum += explore(row, col) if val[/[^\d.]/]
        col += 1
      end
      row += 1
      col = 0
    end

    sum
  end

  def gear_ratios
    sum = 0
    row = 0
    col = 0

    while row < height
      while col < width
        val = @schematic[row][col]
        sum += explore_gear(row, col) if val[/\*/]
        col += 1
      end
      row += 1
      col = 0
    end

    sum
  end

  private

  def explore(row, col)
    adjacent_numbers(row, col).sum
  end

  def explore_gear(row, col)
    nums = adjacent_numbers(row, col)
    return 0 unless nums.size == 2

    nums.reduce(&:*)
  end

  def adjacent_numbers(row, col)
    adjacent_numbers = []
    @visited[row][col] = true
    (row - 1..row + 1).each do |explore_row|
      (col - 1..col + 1).each do |explore_col|
        num = discover_number(explore_row, explore_col)
        adjacent_numbers.push(num) if num != 0
      end
    end

    adjacent_numbers
  end

  def discover_number(row, col)
    # bounds check
    return 0 if row.negative? ||
                row >= height ||
                col.negative? ||
                col >= width ||
                @visited[row][col]

    val = @schematic[row][col]

    # check that it's actually a number
    return 0 unless val[/[0-9]/]

    # add digits to the left
    l = col - 1
    while l >= 0 && is_num(@schematic[row][l])
      val.prepend(@schematic[row][l])
      @visited[row][l] = true
      l -= 1
    end
    r = col + 1
    # add digits to the right
    while r < width && is_num(@schematic[row][r])
      val << @schematic[row][r]
      @visited[row][r] = true
      r += 1
    end

    val.to_i
  end

  def is_num(val)
    !val[/[0-9]/].nil?
  end

  def height
    @schematic.size
  end

  def width
    @schematic[0].size
  end

  def to_grid(schematic)
    schematic.split("\n")
             .map(&:chars)
  end
end

mini_input = "467..114..
...*......
..35..633.
......#..."

test_input = "467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598.."
input = File.read('./input.txt')

eg = EngineSchematic.new(input)
# p eg.schematic
# p eg.visited
# p eg.schematic_sum
p eg.gear_ratios
