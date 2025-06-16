# frozen_string_literal: true

# Controls robot movement within table constraints
class RobotController
  def initialize(robot, table)
    @robot = robot
    @table = table
  end

  def execute(command)
    case command[:type]
    when :place then place_robot(command)
    when :move then move_robot
    when :left then @robot.turn(:left)
    when :right then @robot.turn(:right)
    when :report then report_position
    end
  end

  private

  def place_robot(command)
    return unless @table.valid_position?(command[:x], command[:y])

    @robot.place(command[:x], command[:y], command[:direction])
  end

  def move_robot
    next_position = @robot.next_position
    return unless next_position

    next_x, next_y = next_position
    return unless @table.valid_position?(next_x, next_y)

    @robot.move
  end

  def report_position
    result = @robot.report
    puts result if result
  end
end
