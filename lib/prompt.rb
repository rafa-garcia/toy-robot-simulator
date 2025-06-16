# frozen_string_literal: true

# User prompt system
class Prompt
  HELP = <<~TEXT
    🤖 TOY ROBOT SIMULATOR
    
    Commands:
      PLACE X,Y,NORTH|SOUTH|EAST|WEST
      MOVE
      LEFT
      RIGHT  
      REPORT
    
    Example:
      PLACE 0,0,NORTH
      MOVE
      REPORT
    
    Press Ctrl+C to quit
  TEXT

  def self.welcome
    puts "#{HELP}\n> "
  end
  
  def self.prompt
    print "> "
  end
end
