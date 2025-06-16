# frozen_string_literal: true

# Represents the toy robot with position and direction
class Robot
  DIRECTIONS = %i[NORTH EAST SOUTH WEST].freeze
  POSITION_DELTAS = [[0, 1], [1, 0], [0, -1], [-1, 0]].freeze

  attr_reader :x, :y, :direction

  def initialize
    @placed = false
  end

  def place(x_pos, y_pos, direction)
    return false unless DIRECTIONS.include?(direction)

    @x = x_pos
    @y = y_pos
    @direction = direction
    @placed = true
  end

  def placed?
    @placed
  end

  def report
    return unless placed?

    "#{@x},#{@y},#{@direction}"
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

  def left
    return unless placed?

    turn(-1)
  end

  def right
    return unless placed?

    turn(1)
  end

  private

  def current_direction_index
    DIRECTIONS.index(@direction)
  end

  def turn(offset)
    @direction = DIRECTIONS.rotate(offset)[current_direction_index]
  end
end
