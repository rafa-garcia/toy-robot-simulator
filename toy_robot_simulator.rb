# frozen_string_literal: true

require_relative 'lib/robot'
require_relative 'lib/table'
require_relative 'lib/command_parser'
require_relative 'lib/robot_controller'
require_relative 'lib/logger'

# Handles console output responsibilities
class ConsoleUI
  def display_result(result, command_type)
    puts result if command_type == :report && result
  end

  def show_prompt
    print '> '
  end
end

# Components container for type safety
class SimulatorComponents
  attr_reader :controller, :parser

  def initialize(controller, parser)
    @controller = controller
    @parser = parser
  end
end

# Main entry point for the Toy Robot Simulator
class ToyRobotSimulator
  DEFAULT_TABLE_WIDTH = 5
  DEFAULT_TABLE_HEIGHT = 5

  def self.run(input = $stdin, table_width = DEFAULT_TABLE_WIDTH, table_height = DEFAULT_TABLE_HEIGHT, log_level: :warn)
    setup = create_components(table_width, table_height, log_level)
    ui = ConsoleUI.new

    input.each_line do |line|
      process_command(line, setup, ui, input == $stdin)
    end
  end

  def self.create_components(table_width, table_height, log_level)
    logger = Logger.new(level: log_level)
    table = Table.new(table_width, table_height)
    robot = Robot.new
    controller = RobotController.new(robot, table, logger: logger)
    parser = CommandParser.new
    SimulatorComponents.new(controller, parser)
  end

  def self.process_command(line, setup, console_ui, interactive)
    command = setup.parser.parse(line.strip)
    return unless command

    result = setup.controller.execute(command)
    console_ui.display_result(result, command[:type])
    console_ui.show_prompt if interactive
  end
end
