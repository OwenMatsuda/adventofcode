# frozen_string_literal: true

# n: num cards, l: winning nums, m: elf's cards
# l <= m so O(l) <= O(m)
# Part 1:
#  Brute force: nm^2
#  Sorting + binary search: n(m(log(m)) + m(log(m))) ~= nm(log(m))
#  Convert winning numbers to a set: O(nm)
# Part 2:
#  n iterations over the cards, m to find the num winning cards and m to add to the counts array
#  = O(nm)

class ScratchCards
  def initialize(input)
    @cards = to_cards(input)
  end

  def winnings
    @cards.map { |card| calculate_winning(card[:winning], card[:scratch]) }
          .sum
  end

  def win_scratchcards
    counts = Array.new(@cards.size) { 1 }
    @cards.each_with_index do |card, i|
      # given n winning cards for input i
      (1..num_winning_cards(card[:winning], card[:scratch])).each do |num|
        # add 1 * num of that card you have to each of the cards 1..n after
        counts[i + num] += counts[i]
      end
    end

    counts.sum
  end

  private

  def num_winning_cards(winning_numbers, scratch_numbers)
    win_set = winning_numbers.to_set
    scratch_numbers.count { |num| win_set.include? num }
  end

  def calculate_winning(winning_numbers, scratch_numbers)
    multiplier = -1 + num_winning_cards(winning_numbers, scratch_numbers)

    multiplier >= 0 ? 2**multiplier : 0
  end

  def to_cards(input)
    cards = input.split("\n")
    cards.map do |card|
      winning_numbers, scratch_numbers =
        card.split(':')[1]
            .split('|')
            .map { |num_str| num_str.strip.split(' ') }

      { winning: winning_numbers, scratch: scratch_numbers }
    end
  end
end

mini_input = 'Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53'
test_input = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"
input = File.read('./input.txt')

s = ScratchCards.new(input)
# puts s.winnings
puts s.win_scratchcards
