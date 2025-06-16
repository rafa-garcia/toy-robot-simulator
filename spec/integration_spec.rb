# frozen_string_literal: true

require 'stringio'
require_relative '../lib/toy_robot_simulator'

RSpec.describe 'Integration Tests' do
  let(:output) { StringIO.new }

  before { allow($stdout).to receive(:write) { |text| output.write(text) } }

  describe 'Example test cases from requirements' do
    it 'runs example 1: PLACE 0,0,NORTH; MOVE; REPORT' do
      input = StringIO.new("PLACE 0,0,NORTH\nMOVE\nREPORT\n")
      ToyRobotSimulator.run(input)

      expect(output.string).to eq('0,1,NORTH')
    end

    it 'runs example 2: PLACE 0,0,NORTH; LEFT; REPORT' do
      input = StringIO.new("PLACE 0,0,NORTH\nLEFT\nREPORT\n")
      ToyRobotSimulator.run(input)

      expect(output.string).to eq('0,0,WEST')
    end

    it 'runs example 3: PLACE 1,2,EAST; MOVE; MOVE; LEFT; MOVE; REPORT' do
      input = StringIO.new("PLACE 1,2,EAST\nMOVE\nMOVE\nLEFT\nMOVE\nREPORT\n")
      ToyRobotSimulator.run(input)

      expect(output.string).to eq('3,3,NORTH')
    end
  end

  describe 'Edge cases' do
    it 'ignores commands before valid PLACE' do
      input = StringIO.new("MOVE\nLEFT\nREPORT\nPLACE 1,1,NORTH\nREPORT\n")
      ToyRobotSimulator.run(input)

      expect(output.string).to eq('1,1,NORTH')
    end

    it 'prevents falling off table edges' do
      input = StringIO.new("PLACE 0,0,SOUTH\nMOVE\nREPORT\n")
      ToyRobotSimulator.run(input)

      expect(output.string).to eq('0,0,SOUTH')
    end

    it 'ignores invalid commands' do
      input = StringIO.new("PLACE 1,1,NORTH\nINVALID\nREPORT\n")
      ToyRobotSimulator.run(input)

      expect(output.string).to eq('1,1,NORTH')
    end
  end
end
