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
end
