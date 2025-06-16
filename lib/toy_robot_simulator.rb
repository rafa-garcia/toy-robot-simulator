# frozen_string_literal: true

require_relative 'robot'
require_relative 'table'
require_relative 'command_parser'
require_relative 'robot_controller'

# Main entry point for the Toy Robot Simulator
class ToyRobotSimulator
  def self.run(input = $stdin, table_width = 5, table_height = 5)
    table = Table.new(table_width, table_height)
    robot = Robot.new
    controller = RobotController.new(robot, table)
    parser = CommandParser.new

    input.each_line do |line|
      command = parser.parse(line.strip)
      next unless command

      controller.execute(command)
    end
  end
end
