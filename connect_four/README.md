# Connect Four Implementation Guide

## Game Description
 - Two players play on a board with 6 rows and 7 columns.
 - The goal of the game is to connect exactly four of your pieces in a row in any orientation (horizontal, vertical, diagonal).
 - A spot on the board is only playable if all the spots below are filled.
 - If all the spots are filled, and there is no winner, the game ends in a draw.

## Necessary Implementations

 - def play(board, opp_last, my_last, piece)
 
   - parameters
     - board - a two dimensional list with six rows and seven columns (i.e. board[6][7])
     - opp_last - (row, column) of the opponent's last move; None if opponent skipped his/her turn or this is the first move of the game
     - mylast - (row, column) of the opponent's last move; None if you skipped your last turn or this is the first move of the game
     - piece - a boolean value; signifies your piece on the board (same value throughout the game)

   - return value
     - (row, column) to play
     - if the return value is not a valid spot on the board, your turn will be automatically skipped
     - return None to skip your turn

   - notes
     - each spot has one of None, True, False that signifies empty, Player 1's piece, Player 2's piece respectively
     - this function should return a valid value
     - if both players skip in a row, the game will end in a draw
