# Connect Four Implementation Guide

## Game Description
 - Two players play on a board with 6 rows and 7 columns. Each player has infinite number of pieces.
 - The goal of the game is to connect exactly four of your pieces in a row in any orientation (horizontal, vertical, diagonal).
 - A spot on the board is only playable if all the spots below are NOT empty.
 - If all the spots are filled with no winners, the game ends in a draw.

## Necessary Implementations

 - def play(board, lastspot, mylast, piece, retry)
 
   - parameters
     - board - a two dimensional list with six rows and seven columns (i.e. [6][7])
     - lastspot - a tuple containing (row, column) value of the opponent's last move; (None, None) for the first move of the game and if opponent skipped
     - mylast - a tuple containing (row, column) value of your last move; (None, None) for the first move of the game and if you skipped
     - piece - a boolean value; signifies your piece on the board (same value throughout the game)
     - retry - a boolean value; true if your previous returned value was not a valid spot

   - return value
     - a tuple of consisting of (row, column) value to play
     - if returned value is not a valid spot, this function will be called again without any turn played and with retry as True
     - return (None, None) to skip your turn

   - notes
     - each nested list in 'board' is a row of the playing board
     - each spot has one of None, True, False that signifies respectively empty, Player 1's piece, Player 2's piece
     - this function SHOULD return a valid value within three seconds of the first call
     - after three seconds, your turn will be automatically skipped
     - if both players skip their turns in a row, the game will end in a draw
