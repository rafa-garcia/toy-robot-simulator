# frozen_string_literal: true

# Minimal logger with metaprogramming
class Logger
  LEVELS = { debug: 0, info: 1, warn: 2, error: 3 }.freeze

  def initialize(level: :info, output: $stderr)
    @level = LEVELS[level] || 1
    @output = output
  end

  LEVELS.each do |level, index|
    define_method(level) do |msg|
      log(level, msg, index)
    end
  end

  private

  def log(level, msg, lvl)
    @output.puts("[#{level.upcase}] #{msg}") if lvl >= @level
  end
end
