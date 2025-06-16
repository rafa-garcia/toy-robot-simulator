# frozen_string_literal: true

require_relative '../lib/robot_controller'
require_relative '../lib/robot'
require_relative '../lib/table'
require_relative '../lib/logger'

RSpec.describe RobotController do
  let(:robot) { Robot.new }
  let(:table) { Table.new(5, 5) }
  subject(:controller) { described_class.new(robot, table) }

  describe '#execute' do
    context 'with PLACE command' do
      it 'places robot on valid position' do
        command = { type: :place, x: 1, y: 2, direction: :NORTH }
        result = controller.execute(command)

        expect(result).to be true
        expect(robot).to be_placed
        expect(robot.x).to eq(1)
        expect(robot.y).to eq(2)
        expect(robot.direction).to eq(:NORTH)
      end

      it 'returns false for placement on invalid position' do
        command = { type: :place, x: 5, y: 5, direction: :NORTH }
        result = controller.execute(command)

        expect(result).to be false
        expect(robot).not_to be_placed
      end
    end

    context 'with MOVE command' do
      it 'returns true when move is successful' do
        robot.place(1, 1, :NORTH)
        result = controller.execute({ type: :move })

        expect(result).to be true
        expect(robot.x).to eq(1)
        expect(robot.y).to eq(2)
      end

      it 'returns false when move would cause fall' do
        robot.place(0, 0, :SOUTH)
        result = controller.execute({ type: :move })

        expect(result).to be false
        expect(robot.x).to eq(0)
        expect(robot.y).to eq(0)
      end

      it 'returns false when move blocked on east edge' do
        robot.place(4, 0, :EAST)
        result = controller.execute({ type: :move })

        expect(result).to be false
        expect(robot.x).to eq(4)
        expect(robot.y).to eq(0)
      end
    end

    context 'with LEFT command' do
      it 'returns true and turns robot left' do
        robot.place(0, 0, :NORTH)
        result = controller.execute({ type: :left })

        expect(result).to be true
        expect(robot.direction).to eq(:WEST)
      end
    end

    context 'with RIGHT command' do
      it 'returns true and turns robot right' do
        robot.place(0, 0, :NORTH)
        result = controller.execute({ type: :right })

        expect(result).to be true
        expect(robot.direction).to eq(:EAST)
      end
    end

    context 'with REPORT command' do
      it 'returns robot position' do
        robot.place(2, 3, :SOUTH)
        result = controller.execute({ type: :report })
        expect(result).to eq('2,3,SOUTH')
      end

      it 'returns nil when robot not placed' do
        result = controller.execute({ type: :report })
        expect(result).to be_nil
      end
    end
  end

  describe 'logger dependency injection' do
    let(:logger) { instance_double(Logger) }

    it 'works without logger' do
      controller = described_class.new(robot, table) # No logger

      expect { controller.execute({ type: :place, x: 1, y: 2, direction: :NORTH }) }.not_to raise_error
      expect { controller.execute({ type: :move }) }.not_to raise_error
    end

    it 'logs debug and info messages when placing robot' do
      controller = described_class.new(robot, table, logger: logger)

      expect(logger).to receive(:debug).with('Executing: place')
      expect(logger).to receive(:info).with('Robot placed at 1,2,NORTH')
      controller.execute({ type: :place, x: 1, y: 2, direction: :NORTH })
    end

    it 'logs warning when move is blocked' do
      robot.place(0, 0, :SOUTH)
      controller = described_class.new(robot, table, logger: logger)

      expect(logger).to receive(:debug).with('Executing: move')
      expect(logger).to receive(:warn).with('Move blocked - would fall off table')
      controller.execute({ type: :move })
    end

    it 'logs debug message when robot moves successfully' do
      robot.place(1, 1, :NORTH)
      controller = described_class.new(robot, table, logger: logger)

      expect(logger).to receive(:debug).with('Executing: move')
      expect(logger).to receive(:debug).with('Robot moved to 1,2')
      controller.execute({ type: :move })
    end

    it 'logs debug message when executing turn commands' do
      robot.place(1, 1, :NORTH)
      controller = described_class.new(robot, table, logger: logger)

      expect(logger).to receive(:debug).with('Executing: left')
      controller.execute({ type: :left })
    end
  end
end
