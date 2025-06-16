# frozen_string_literal: true

require_relative '../lib/command_parser'

RSpec.describe CommandParser do
  subject(:parser) { described_class.new }

  describe '#parse' do
    it 'parses MOVE command' do
      result = parser.parse('MOVE')
      expect(result).to eq({ type: :move })
    end

    it 'parses LEFT command' do
      result = parser.parse('LEFT')
      expect(result).to eq({ type: :left })
    end

    it 'parses RIGHT command' do
      result = parser.parse('RIGHT')
      expect(result).to eq({ type: :right })
    end

    it 'parses REPORT command' do
      result = parser.parse('REPORT')
      expect(result).to eq({ type: :report })
    end

    it 'parses PLACE command with valid parameters' do
      result = parser.parse('PLACE 1,2,NORTH')
      expect(result).to eq({ type: :place, x: 1, y: 2, direction: :NORTH })
    end

    it 'parses PLACE command case insensitively' do
      result = parser.parse('place 1,2,north')
      expect(result).to eq({ type: :place, x: 1, y: 2, direction: :NORTH })
    end

    it 'handles commands case insensitively' do
      expect(parser.parse('move')).to eq({ type: :move })
      expect(parser.parse('left')).to eq({ type: :left })
      expect(parser.parse('right')).to eq({ type: :right })
      expect(parser.parse('report')).to eq({ type: :report })
    end

    it 'returns nil for empty input' do
      expect(parser.parse('')).to be_nil
    end

    it 'returns nil for invalid commands' do
      expect(parser.parse('INVALID')).to be_nil
      expect(parser.parse('PLACE')).to be_nil
      expect(parser.parse('PLACE 1')).to be_nil
      expect(parser.parse('PLACE 1,2')).to be_nil
      expect(parser.parse('PLACE 1,2,INVALID')).to be_nil
    end
  end
end
