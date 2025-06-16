# frozen_string_literal: true

require 'stringio'
require_relative '../toy_robot_simulator'
require_relative '../lib/logger'

RSpec.describe 'Integration Tests' do
  let(:output) { StringIO.new }
  let(:error_output) { StringIO.new }

  before do
    allow($stdout).to receive(:write) { |text| output.write(text) }
    allow($stdout).to receive(:puts) { |msg| output.puts(msg) }
    allow($stdout).to receive(:print) { |msg| output.print(msg) }
    allow($stderr).to receive(:puts) { |msg| error_output.puts(msg) }
  end

  describe 'Example test cases from requirements' do
    it 'runs example 1: PLACE 0,0,NORTH; MOVE; REPORT' do
      input = StringIO.new("PLACE 0,0,NORTH\nMOVE\nREPORT\n")
      ToyRobotSimulator.run(input)

      expect(output.string).to eq("0,1,NORTH\n")
    end

    it 'runs example 2: PLACE 0,0,NORTH; LEFT; REPORT' do
      input = StringIO.new("PLACE 0,0,NORTH\nLEFT\nREPORT\n")
      ToyRobotSimulator.run(input)

      expect(output.string).to eq("0,0,WEST\n")
    end

    it 'runs example 3: PLACE 1,2,EAST; MOVE; MOVE; LEFT; MOVE; REPORT' do
      input = StringIO.new("PLACE 1,2,EAST\nMOVE\nMOVE\nLEFT\nMOVE\nREPORT\n")
      ToyRobotSimulator.run(input)

      expect(output.string).to eq("3,3,NORTH\n")
    end
  end

  describe 'Edge cases' do
    it 'ignores commands before valid PLACE' do
      input = StringIO.new("MOVE\nLEFT\nREPORT\nPLACE 1,1,NORTH\nREPORT\n")
      ToyRobotSimulator.run(input)

      expect(output.string).to eq("1,1,NORTH\n")
    end

    it 'prevents falling off table edges' do
      input = StringIO.new("PLACE 0,0,SOUTH\nMOVE\nREPORT\n")
      ToyRobotSimulator.run(input)

      expect(output.string).to eq("0,0,SOUTH\n")
    end

    it 'ignores invalid commands' do
      input = StringIO.new("PLACE 1,1,NORTH\nINVALID\nREPORT\n")
      ToyRobotSimulator.run(input)

      expect(output.string).to eq("1,1,NORTH\n")
    end
  end

  describe 'Logging integration' do
    it 'sends application output to stdout and logs to stderr' do
      input = StringIO.new("PLACE 0,0,SOUTH\nMOVE\nREPORT\n")

      ToyRobotSimulator.run(input, log_level: :warn)

      # Application output (REPORT) goes to stdout
      expect(output.string).to include('0,0,SOUTH')

      # Warning logs go to stderr
      expect(error_output.string).to include('[WARN] Move blocked')

      # Logs don't contaminate application output
      expect(output.string).not_to include('[WARN]')
    end

    it 'works silently when log level is error' do
      input = StringIO.new("PLACE 0,0,SOUTH\nMOVE\nREPORT\n")

      ToyRobotSimulator.run(input, log_level: :error)

      expect(output.string).to include('0,0,SOUTH')

      # No warning logs at error level
      expect(error_output.string).not_to include('[WARN]')
    end

    it 'shows debug logs when level is debug' do
      input = StringIO.new("PLACE 1,1,NORTH\nMOVE\nREPORT\n")

      ToyRobotSimulator.run(input, log_level: :debug)

      expect(output.string).to include('1,2,NORTH')

      # Debug logs appear in stderr
      expect(error_output.string).to include('[DEBUG] Executing: place')
      expect(error_output.string).to include('[DEBUG] Executing: move')
      expect(error_output.string).to include('[INFO] Robot placed')
    end

    it 'uses warn level by default' do
      input = StringIO.new("PLACE 0,0,NORTH\nREPORT\n")

      ToyRobotSimulator.run(input) # No log_level specified

      expect(output.string).to include('0,0,NORTH')
      # Should not see debug/info logs at warn level
      expect(error_output.string).not_to include('[DEBUG]')
      expect(error_output.string).not_to include('[INFO]')
    end
  end
end
