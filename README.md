# Toy Robot Simulator

A Ruby implementation of a toy robot simulator that moves on a configurable tabletop (default 5x5), following SOLID principles with comprehensive test coverage.

## Description

The application simulates a toy robot moving on a configurable square tabletop (default 5 units x 5 units). The robot must be prevented from falling to destruction. Any movement that would result in the robot falling from the table is prevented, but further valid movement commands are still allowed.

## Commands

- `PLACE X,Y,F` - Put the toy robot on the table in position X,Y and facing NORTH, SOUTH, EAST or WEST
- `MOVE` - Move the toy robot one unit forward in the direction it is currently facing
- `LEFT` - Rotate the robot 90 degrees counter-clockwise without changing position
- `RIGHT` - Rotate the robot 90 degrees clockwise without changing position
- `REPORT` - Display the X,Y and F of the robot

## Usage

### Command line

```bash
# Run with standard input
./bin/toy_robot

# Run with a file
./bin/toy_robot < test_data/example1.txt
```

### Examples

**Example 1:**
```
PLACE 0,0,NORTH
MOVE
REPORT
```
Output: `0,1,NORTH`

**Example 2:**
```
PLACE 0,0,NORTH
LEFT
REPORT
```
Output: `0,0,WEST`

**Example 3:**
```
PLACE 1,2,EAST
MOVE
MOVE
LEFT
MOVE
REPORT
```
Output: `3,3,NORTH`

## Installation

```bash
# Install dependencies (if using Gemfile)
bundle install

# Or run without bundler (only requires standard Ruby)
ruby bin/toy_robot
```

## Testing

Run the full test suite:

```bash
# Using RSpec
rspec

# Run specific test files
rspec spec/robot_spec.rb
rspec spec/integration_spec.rb
```

## Architecture

The application follows SOLID principles with clear separation of concerns:

### Classes

- **Table** (`lib/table.rb`) - Handles table boundaries and position validation
- **Robot** (`lib/robot.rb`) - Encapsulates robot state and movements
- **RobotController** (`lib/robot_controller.rb`) - Controls robot movement within table constraints
- **CommandParser** (`lib/command_parser.rb`) - Parses string commands into structured data
- **ToyRobotSimulator** (`toy_robot_simulator.rb`) - Main application entry point

### SOLID principles applied

1. **Single Responsibility Principle**: Each class has one clear responsibility
2. **Open/Closed Principle**: Easy to extend with new commands or table types
3. **Liskov Substitution Principle**: Components can be substituted without breaking functionality
4. **Interface Segregation Principle**: Clean, minimal interfaces between components
5. **Dependency Inversion Principle**: High-level modules don't depend on low-level details

## Design decisions

- **Immutable directions**: Using a constant array for direction management
- **Boundary checking**: Separate table class handles position validation
- **Command pattern**: Clean separation between parsing and execution
- **Defensive programming**: Robot ignores invalid commands gracefully
- **Flexible table size**: Configurable table dimensions with 5x5 default for backward compatibility
- **Short and focused**: Each class is under 60 lines, methods are concise

## What could be done given more time

- **User Experience**: Clear prompts and help text to guide users on available commands
- **CLI Configuration**: Add command-line options for table size (e.g., `--size 10x10`)
- **Validation**: More robust input validation and error messages
- **Logging**: Add structured logging for debugging
- **UI**: Interactive CLI with arrow keys and visual table display
- **Extensions**: Support for multiple robots, obstacles, or different movement patterns
- **Persistence**: Save/load robot state
- **Performance**: Optimize for handling large command sequences
- **Metrics**: Performance monitoring and analytics
