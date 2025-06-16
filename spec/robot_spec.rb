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
      robot.place(1, 2, :NORTH)
      expect(robot.x).to eq(1)
      expect(robot.y).to eq(2)
      expect(robot.direction).to eq(:NORTH)
      expect(robot).to be_placed
    end

    it 'rejects invalid direction' do
      robot.place(1, 2, 'INVALID')
      expect(robot).not_to be_placed
    end

    it 'allows re-placement' do
      robot.place(1, 1, :NORTH)
      robot.place(2, 3, :SOUTH)
      expect(robot.x).to eq(2)
      expect(robot.y).to eq(3)
      expect(robot.direction).to eq(:SOUTH)
    end
  end

  describe '#report' do
    it 'returns nil when not placed' do
      expect(robot.report).to be_nil
    end

    it 'returns position and direction when placed' do
      robot.place(3, 4, :SOUTH)
      expect(robot.report).to eq('3,4,SOUTH')
    end
  end

  describe '#move' do
    it 'ignores move when not placed' do
      expect { robot.move }.not_to(change { [robot.x, robot.y] })
    end

    context 'when placed' do
      it 'moves north when facing north' do
        robot.place(2, 2, :NORTH)
        robot.move
        expect(robot.y).to eq(3)
        expect(robot.x).to eq(2)
      end

      it 'moves south when facing south' do
        robot.place(2, 2, :SOUTH)
        robot.move
        expect(robot.y).to eq(1)
        expect(robot.x).to eq(2)
      end

      it 'moves east when facing east' do
        robot.place(2, 2, :EAST)
        robot.move
        expect(robot.x).to eq(3)
        expect(robot.y).to eq(2)
      end

      it 'moves west when facing west' do
        robot.place(2, 2, :WEST)
        robot.move
        expect(robot.x).to eq(1)
        expect(robot.y).to eq(2)
      end
    end
  end

  describe '#turn' do
    context 'with :left direction' do
      it 'ignores turn when not placed' do
        expect { robot.turn(:left) }.not_to(change { robot.direction })
      end

      context 'when placed' do
        before { robot.place(0, 0, :NORTH) }

        it 'turns from NORTH to WEST' do
          robot.turn(:left)
          expect(robot.direction).to eq(:WEST)
        end

        it 'turns from WEST to SOUTH' do
          robot.place(0, 0, :WEST)
          robot.turn(:left)
          expect(robot.direction).to eq(:SOUTH)
        end

        it 'turns from SOUTH to EAST' do
          robot.place(0, 0, :SOUTH)
          robot.turn(:left)
          expect(robot.direction).to eq(:EAST)
        end

        it 'turns from EAST to NORTH' do
          robot.place(0, 0, :EAST)
          robot.turn(:left)
          expect(robot.direction).to eq(:NORTH)
        end
      end
    end

    context 'with :right direction' do
      it 'ignores turn when not placed' do
        expect { robot.turn(:right) }.not_to(change { robot.direction })
      end

      context 'when placed' do
        before { robot.place(0, 0, :NORTH) }

        it 'turns from NORTH to EAST' do
          robot.turn(:right)
          expect(robot.direction).to eq(:EAST)
        end

        it 'turns from EAST to SOUTH' do
          robot.place(0, 0, :EAST)
          robot.turn(:right)
          expect(robot.direction).to eq(:SOUTH)
        end

        it 'turns from SOUTH to WEST' do
          robot.place(0, 0, :SOUTH)
          robot.turn(:right)
          expect(robot.direction).to eq(:WEST)
        end

        it 'turns from WEST to NORTH' do
          robot.place(0, 0, :WEST)
          robot.turn(:right)
          expect(robot.direction).to eq(:NORTH)
        end
      end
    end
  end
end
