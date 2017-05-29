# Battleship Implementation Guide

## Game Description
 - Each player has 
   - a board
   - four-block-long battleship x1
   - three-block-long cruisers x2
   - two-block-long destroyers x3
   - one-block-long submarines x4
 - Before the game starts, each player deploys all of the ships on the board. 
 - For each turn, a player selects the desired attack coordinate on opponent's board.
 - A ship sinks if and only if all the blocks occupied by the ship are attacked.
 - First player to sink all of the opponent's ships wins.
 - All player functions will have 1 second to return a valid result.

## Game Objects
- board: a two dimensional array of blocks (e.g. board[row][column])
- block: makes up the board
  - block.is_occupied: True or False depending on if ship overlaps the block; None if unknown
  - block.is_hit: True or False depending on if the block was attacked

## Necessary Implementations

 - def deploy(width, height)

   - parameters
     - width - number of blocks representing the width of the board
     - height - number of blocks representing the height of the board

   - return value
     - a list of tuples; each tuple in the form of (row, column, orientation)
     - the ship will be placed at specified row, column value and in the specified orientation
     - orientation has two possible values: 'H' and 'V', representing horizontal (to right) and vertical (to downwards)
     - the list should contain the exact number of ships
     - the order of the tuples represent the size of the ships (i.e. 0th tuple will be regarded as the longest ship)

   - notes
     - this function will be called before the game starts
     - this function should return a valid placement of ships
     - if the deployment is invalid, you will automatically lose the game
     - if the function steps out of the sandbox boundary, the deployment is considered invalid
     - if both players fail to provide valid deployment, the game is considered invalid

 - def play(board, attacks, last_attacked, sunk)

   - parameters
     - board - the board your ships are deployed on
             - each block is either 0, 1, 2, or 3 representing water, ship, attacked water, or attacked ship, respectively
     - attacks - the board your opponent's ships are deployed on
               - each block is either 0, 1, or 2 representing not yet attacked, attack fail, or attack success, respectively
     - last_attacked - (row, column) of your opponent's last attack; None if your opponent skipped his/her turn or if this is the first move of the game
     - sunk - the length of the ship you sank with your last move if any; 0 if no ship sank from your last move

   - return value
     - (row, column) to attack on the opponent's board
     - row and column values should be a valid coordinate on the board
     - if the value is not a valid attack spot, your turn will be skipped
     - return None to skip your turn
     - already attacked coordinate is NOT a valid coordinate

   - notes
     - this function should return a valid coordinate
     - if the attack coordinate is not valid, your turn will be automatically skipped
     - if the function steps out of the sandbox boundary, the return value is considered invalid
     - if both players skip their turns in a row, the game will end in a draw

## Sandbox Boundaries
All mathematical functions are allowed. Also, the players are allowed an access to the Block class (passed within the boards).
