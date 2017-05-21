def play(board, lastspot, mylast, piece, retry):
    for c in range(len(board[0])):
        for r in range(len(board)-1, -1, -1):
            if board[r][c] == None:
                return (r, c)
    return (None, None)
