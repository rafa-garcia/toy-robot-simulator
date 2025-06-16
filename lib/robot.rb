# frozen_string_literal: true

# Represents the toy robot with position and direction
class Robot
  DIRECTIONS = %i[NORTH EAST SOUTH WEST].freeze
  # Movement deltas [x, y] for NORTH, EAST, SOUTH, WEST respectively
  POSITION_DELTAS = [[0, 1], [1, 0], [0, -1], [-1, 0]].freeze

  attr_reader :x, :y, :direction

  def place(x_pos, y_pos, direction)
    return unless [x_pos, y_pos].all? { |c| c.is_a?(Integer) && c >= 0 } && DIRECTIONS.include?(direction)

    @x = x_pos
    @y = y_pos
    @direction = direction
  end

  def placed?
    !!@direction
  end

  def report
    return unless placed?

    [@x, @y, @direction].join(',')
  end

  def next_position
    return unless placed?

    dx, dy = POSITION_DELTAS[current_direction_index]
    [@x + dx, @y + dy]
  end

  def move
    new_position = next_position
    @x, @y = new_position if new_position
  end

  def turn(direction)
    return unless placed?

    # Calculate new direction using modular arithmetic: left = -1, right = +1
    offset = direction == :left ? -1 : 1
    new_index = (current_direction_index + offset) % DIRECTIONS.length
    @direction = DIRECTIONS[new_index]
  end

  private

  def current_direction_index
    DIRECTIONS.index(@direction)
  end
end
