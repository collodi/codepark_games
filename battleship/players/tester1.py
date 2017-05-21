def deploy(w, h):
    return [(0, 0, 'S'), (0, 2, 'S'), (0, 4, 'S'), (0, 6, 'S'), (0, 8, 'S'), (9, 0, 'E'), (9, 4, 'E'), (9, 6, 'E'), (9, 8, 'E'), (4, 8, 'E')]

def play(board, attacks, lastspot, mylast, retry):
    for c in range(len(attacks[0])):
        for r in range(len(attacks)):
            if attacks[r][c] == 0:
                return (r, c)
    return (None, None)
