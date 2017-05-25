# Battleship Implementation Guide

## Game Description
 - Each player has a 10x10 board, a four-block-long battleship, two three-block-long cruisers, three two-block-long destroyers, and four one-block-long submarines.
 - Before the game starts, each player positions all of the ships on the board. A ship cannot be adjacent to any other ship, even diagonally.
 - For each turn, a player selects the desired attack coordinate on opponent's board.
 - A ship sinks if and only if all the blocks occupied by the ship is attacked.
 - First player to sink all of the opponent's ships wins.

## Necessary Implementations

 - def deploy(width, height)

   - parameters
     - width - number of blocks representing the width of the board
     - height - number of blocks representing the height of the board

   - return value
     - a list of tuples; each tuple in the form of (row, column, direction)
     - the ship will be placed at specified row, column value and in the specified direction
     - direction has four possible values: 'N', 'E', 'S', 'W' representing up, right, down, left respectively
     - the list should contain the total number of ships
     - the order of the tuples represent the size of the ships (i.e. 0th tuple will be regarded as the longest ship)

   - notes
     - this function will be called before the game starts
     - this function SHOULD return a valid placement of ships within three seconds of the first call
     - after three seconds, you will automatically lose the game
     - if both players fail to provide valid ship placements, the game is considered invalid

 - def play(board, attacks, lastspot, mylast, retry)

   - parameters
     - board - the board your ships are deployed on; represented by a two dimensional list with each nested list being a row
             - each block is either 0, 1, 2, or 3 representing water, occupied, attacked water, or attacked ship, respectively
     - attacks - the board your opponent's ships are deployed on; represented in the same way as 'board'
               - each block is either 0, 1, or 2 representing not yet attacked, attack fail, or attack success, respectively
     - lastspot - a tuple having (row, column) values of your opponent's last attack; (None, None) if your opponent skipped or no move has been played yet
     - mylast - a tuple having (row, column) values of your last attack; (None, None) if you skipped or no move has been played yet
     - retry - a boolean value; True if your previous move was not a valid spot

   - return value
     - a tuple consisting of (row, column) values to attack on the opponent's board
     - row, column values should be positive integers that represent a valid coordinate on the board
     - if the value is not a valid attack spot, the function will be called again without any turn played
     - return (None, None) to skip your turn
     - already attacked coordinate is NOT a valid coordinate

   - notes
     - this function should return a valid coordinate within three seconds of the first call
     - after three seconds, your turn will be automatically skipped
     - if both players skip their turns in a row, the game will end in a draw
