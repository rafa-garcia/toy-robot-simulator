# frozen_string_literal: true

require_relative 'lib/robot'
require_relative 'lib/table'
require_relative 'lib/command_parser'
require_relative 'lib/robot_controller'

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

      result = controller.execute(command)
      puts result if command[:type] == :report && result
    end
  end
end
