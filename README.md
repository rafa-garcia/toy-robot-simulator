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

### Command Line

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
