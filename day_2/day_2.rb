# frozen_string_literal: true

# reveal looks like 3 blue
def to_color_hash(reveal)
  num, color = reveal.strip.split

  { color.to_sym => num.to_i }
end

# reveal_str looks like "3 blue, 4 red"
def to_reveal(reveal_str)
  reveal_str.split(',')
            .map { |reveal| to_color_hash(reveal) }
            .reduce({}, :merge)
end

def valid_reveal?(reveal)
  valid_red = !reveal[:red] || reveal[:red] <= 12
  valid_green = !reveal[:green] || reveal[:green] <= 13
  valid_blue = !reveal[:blue] || reveal[:blue] <= 14

  valid_red && valid_green && valid_blue
end

def possible_games(input)
  games = input.split("\n")

  valid_reveals = games.map do |game|
    reveals = game.split(':')[1]
                  .split(';')
                  .map { |reveal_str| to_reveal(reveal_str.strip) }
    reveals.all? { |reveal| valid_reveal?(reveal) }
  end
  valid_reveals.each_with_index.sum { |reveal, index| reveal ? index + 1 : 0 }
end

def power(reveal)
  return 0 if !reveal[:green] || !reveal[:red] || !reveal[:blue]

  reveal[:green] * reveal[:red] * reveal[:blue]
end

def minimum_cubes(input)
  games = input.split("\n")

  powers = games.map do |game|
    reveals = game.split(':')[1]
                  .split(';')
                  .map { |reveal_str| to_reveal(reveal_str.strip) }
    min_cubes = reveals.reduce({}) { |res, reveal| res.merge(reveal) { |_, old, new| [old, new].max } }
    power(min_cubes)
  end

  powers.sum
end

mini_input = 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green'
test_input = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"

input = File.read('./input.txt')

# puts possible_games(input)
puts minimum_cubes(input)
