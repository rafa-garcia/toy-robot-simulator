# frozen_string_literal: true

# Parses command strings into command objects
class CommandParser
  PLACE_REGEX = /\APLACE\s+(\d+),(\d+),(NORTH|SOUTH|EAST|WEST)\z/i.freeze

  def parse(input)
    return nil if input.empty?

    case input.upcase
    when 'MOVE'   then { type: :move }
    when 'LEFT'   then { type: :left }
    when 'RIGHT'  then { type: :right }
    when 'REPORT' then { type: :report }
    else
      parse_place_command(input)
    end
  end

  private

  def parse_place_command(input)
    match = input.match(PLACE_REGEX)
    return nil unless match

    {
      type: :place,
      x: match[1].to_i,
      y: match[2].to_i,
      direction: match[3].upcase.to_sym
    }
  end
end
