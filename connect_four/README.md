# Connect Four Implementation Guide

## Game Description
 - Two players play on a board with 6 rows and 7 columns.
 - The goal of the game is to connect exactly four of your pieces in any orientation (horizontal, vertical, diagonal).
 - A spot on the board is only playable if all the spots below are filled.
 - If all the spots are filled, and there is no winner, the game ends in a draw.

## Necessary Implementations

 - def play(board, opponent_last, my_last, piece)
 
   - parameters
     - board - a two dimensional list with six rows and seven columns (i.e. board[6][7])
     - opponent_last - opponent's last move in (row, column); nil if opponent skipped his/her turn or this is the first move of the game
     - my_last - your last move in (row, column); nil if you skipped your last turn or this is the first move of the game
     - piece - true or false; signifies your piece on the board

   - return value
     - (row, column) to play
     - if the return value is not a valid spot on the board, your turn will be automatically skipped
     - return nil to skip your turn

   - notes
     - each spot has one of nil, true, false that signifies empty, player 1's piece, player 2's piece respectively
     - if both players skip in a row, the game will end in a draw
