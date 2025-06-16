# frozen_string_literal: true

require_relative '../lib/robot'

RSpec.describe Robot do
  subject(:robot) { described_class.new }

  describe '#initialize' do
    it 'starts unplaced' do
      expect(robot).not_to be_placed
    end
  end

  describe '#place' do
    it 'places robot at valid position with valid direction' do
      expect(robot.place(1, 2, 'NORTH')).to be true
      expect(robot.x).to eq(1)
      expect(robot.y).to eq(2)
      expect(robot.direction).to eq('NORTH')
      expect(robot).to be_placed
    end

    it 'rejects invalid direction' do
      expect(robot.place(1, 2, 'INVALID')).to be false
      expect(robot).not_to be_placed
    end

    it 'allows re-placement' do
      robot.place(1, 1, 'NORTH')
      robot.place(2, 3, 'SOUTH')
      expect(robot.x).to eq(2)
      expect(robot.y).to eq(3)
      expect(robot.direction).to eq('SOUTH')
    end
  end

  describe '#report' do
    it 'returns nil when not placed' do
      expect(robot.report).to be_nil
    end

    it 'returns position and direction when placed' do
      robot.place(3, 4, 'SOUTH')
      expect(robot.report).to eq('3,4,SOUTH')
    end
  end
end
