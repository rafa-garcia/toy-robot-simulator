# frozen_string_literal: true

# Controls robot movement within table constraints
class RobotController
  def initialize(robot, table, logger: nil)
    @robot = robot
    @table = table
    @logger = logger
  end

  def execute(command)
    @logger&.debug("Executing: #{command[:type]}")
    case command[:type]
    when :place then place_robot(command)
    when :move then move_robot
    when :left then @robot.turn(:left)
    when :right then @robot.turn(:right)
    when :report then @robot.report
    end
  end

  private

  def place_robot(command)
    return unless @table.valid_position?(command[:x], command[:y])

    @robot.place(command[:x], command[:y], command[:direction])
    @logger&.info("Robot placed at #{command[:x]},#{command[:y]},#{command[:direction]}")
  end

  def move_robot
    next_position = @robot.next_position
    return unless next_position

    next_x, next_y = next_position
    unless @table.valid_position?(next_x, next_y)
      @logger&.warn('Move blocked - would fall off table')
      return
    end

    @robot.move
    @logger&.debug("Robot moved to #{next_x},#{next_y}")
  end
end
