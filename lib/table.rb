# frozen_string_literal: true

# Represents the table with boundaries
class Table
  attr_reader :width, :height

  def initialize(width, height)
    @width = width
    @height = height
  end

  def valid_position?(x_pos, y_pos)
    x_pos >= 0 && x_pos < @width && y_pos >= 0 && y_pos < @height
  end
end
