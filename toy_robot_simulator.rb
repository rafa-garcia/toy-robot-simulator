# frozen_string_literal: true

require_relative 'lib/robot'
require_relative 'lib/table'
require_relative 'lib/command_parser'
require_relative 'lib/robot_controller'
require_relative 'lib/logger'

# Main entry point for the Toy Robot Simulator
class ToyRobotSimulator
  DEFAULT_TABLE_WIDTH = 5
  DEFAULT_TABLE_HEIGHT = 5

  def self.run(input = $stdin, table_width = DEFAULT_TABLE_WIDTH, table_height = DEFAULT_TABLE_HEIGHT, log_level: :warn)
    setup = create_components(table_width, table_height, log_level)

    input.each_line do |line|
      process_command(line, setup, input == $stdin)
    end
  end

  def self.create_components(table_width, table_height, log_level)
    logger = Logger.new(level: log_level)
    table = Table.new(table_width, table_height)
    robot = Robot.new
    controller = RobotController.new(robot, table, logger: logger)
    parser = CommandParser.new
    { controller: controller, parser: parser }
  end

  def self.process_command(line, setup, interactive)
    command = setup[:parser].parse(line.strip)
    return unless command

    result = setup[:controller].execute(command)
    puts result if command[:type] == :report && result
    print '> ' if interactive
  end
end
