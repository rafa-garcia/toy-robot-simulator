# frozen_string_literal: true

# Represents the table with boundaries
class Table
  attr_reader :width, :height

  def initialize(width, height)
    raise ArgumentError unless [width, height].all? { |d| d.is_a?(Integer) && d.positive? }
  
    @width = width
    @height = height
  end

  def valid_position?(x_pos, y_pos)
    (0...@width).cover?(x_pos) && (0...@height).cover?(y_pos)
  end
end
