# frozen_string_literal: true

require_relative '../lib/robot_controller'
require_relative '../lib/robot'
require_relative '../lib/table'

RSpec.describe RobotController do
  let(:robot) { Robot.new }
  let(:table) { Table.new(5, 5) }
  subject(:controller) { described_class.new(robot, table) }

  describe '#execute' do
    context 'with PLACE command' do
      it 'places robot on valid position' do
        command = { type: :place, x: 1, y: 2, direction: :NORTH }
        controller.execute(command)

        expect(robot).to be_placed
        expect(robot.x).to eq(1)
        expect(robot.y).to eq(2)
        expect(robot.direction).to eq(:NORTH)
      end

      it 'ignores placement on invalid position' do
        command = { type: :place, x: 5, y: 5, direction: :NORTH }
        controller.execute(command)

        expect(robot).not_to be_placed
      end
    end

    context 'with MOVE command' do
      it 'moves robot when safe' do
        robot.place(1, 1, :NORTH)
        controller.execute({ type: :move })

        expect(robot.x).to eq(1)
        expect(robot.y).to eq(2)
      end

      it 'prevents robot from falling off table' do
        robot.place(0, 0, :SOUTH)
        controller.execute({ type: :move })

        expect(robot.x).to eq(0)
        expect(robot.y).to eq(0)
      end

      it 'prevents robot from falling off east edge' do
        robot.place(4, 0, :EAST)
        controller.execute({ type: :move })

        expect(robot.x).to eq(4)
        expect(robot.y).to eq(0)
      end
    end

    context 'with LEFT command' do
      it 'turns robot left' do
        robot.place(0, 0, :NORTH)
        controller.execute({ type: :left })

        expect(robot.direction).to eq(:WEST)
      end
    end

    context 'with RIGHT command' do
      it 'turns robot right' do
        robot.place(0, 0, :NORTH)
        controller.execute({ type: :right })

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
end
