# frozen_string_literal: true

# Represents the toy robot with position and direction
class Robot
  DIRECTIONS = %i[NORTH EAST SOUTH WEST].freeze

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

  def move
    return unless placed?

    case @direction
    when :NORTH then @y += 1
    when :SOUTH then @y -= 1
    when :EAST  then @x += 1
    when :WEST  then @x -= 1
    end
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

  def turn(offset)
    @direction = DIRECTIONS.rotate(offset)[DIRECTIONS.index(@direction)]
  end
end
