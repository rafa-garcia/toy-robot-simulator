# frozen_string_literal: true

# Represents the table with boundaries
class Table
  attr_reader :width, :height

  def initialize(width, height)
    @width = width
    @height = height
  end
end
