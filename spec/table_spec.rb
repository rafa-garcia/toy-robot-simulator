# frozen_string_literal: true

require_relative '../lib/table'

RSpec.describe Table do
  subject(:table) { described_class.new(5, 5) }

  describe '#initialize' do
    it 'sets width and height' do
      expect(table.width).to eq(5)
      expect(table.height).to eq(5)
    end
  end

  describe '#valid_position?' do
    it 'returns true for valid positions' do
      expect(table.valid_position?(0, 0)).to be true
      expect(table.valid_position?(4, 4)).to be true
      expect(table.valid_position?(2, 3)).to be true
    end

    it 'returns false for negative positions' do
      expect(table.valid_position?(-1, 0)).to be false
      expect(table.valid_position?(0, -1)).to be false
    end

    it 'returns false for positions beyond boundaries' do
      expect(table.valid_position?(5, 0)).to be false
      expect(table.valid_position?(0, 5)).to be false
    end
  end
end
