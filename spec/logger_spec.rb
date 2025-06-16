# frozen_string_literal: true

require_relative '../lib/logger'

RSpec.describe Logger do
  let(:output) { StringIO.new }

  describe '#initialize' do
    it 'sets default level to info' do
      logger = Logger.new(output: output)
      logger.debug('debug message')
      logger.info('info message')

      expect(output.string).to include('[INFO] info message')
      expect(output.string).not_to include('[DEBUG] debug message')
    end

    it 'accepts custom log level' do
      logger = Logger.new(level: :debug, output: output)
      logger.debug('debug message')

      expect(output.string).to include('[DEBUG] debug message')
    end

    it 'defaults to stderr output' do
      logger = Logger.new
      expect(logger.instance_variable_get(:@output)).to eq($stderr)
    end
  end

  describe 'log levels' do
    let(:logger) { Logger.new(level: :debug, output: output) }

    it 'logs debug messages' do
      logger.debug('debug test')
      expect(output.string).to eq("[DEBUG] debug test\n")
    end

    it 'logs info messages' do
      logger.info('info test')
      expect(output.string).to eq("[INFO] info test\n")
    end

    it 'logs warn messages' do
      logger.warn('warn test')
      expect(output.string).to eq("[WARN] warn test\n")
    end

    it 'logs error messages' do
      logger.error('error test')
      expect(output.string).to eq("[ERROR] error test\n")
    end
  end

  describe 'level filtering' do
    it 'filters debug when level is info' do
      logger = Logger.new(level: :info, output: output)
      logger.debug('should not appear')
      logger.info('should appear')

      expect(output.string).to eq("[INFO] should appear\n")
    end

    it 'filters debug and info when level is warn' do
      logger = Logger.new(level: :warn, output: output)
      logger.debug('no')
      logger.info('no')
      logger.warn('yes')
      logger.error('yes')

      expected = "[WARN] yes\n[ERROR] yes\n"
      expect(output.string).to eq(expected)
    end

    it 'only shows errors when level is error' do
      logger = Logger.new(level: :error, output: output)
      logger.debug('no')
      logger.info('no')
      logger.warn('no')
      logger.error('yes')

      expect(output.string).to eq("[ERROR] yes\n")
    end
  end

  describe 'invalid level' do
    it 'defaults to info level for invalid level' do
      logger = Logger.new(level: :invalid, output: output)
      logger.debug('debug')
      logger.info('info')

      expect(output.string).to include('[INFO] info')
      expect(output.string).not_to include('[DEBUG] debug')
    end
  end
end
