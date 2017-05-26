def deploy(w, h):
    return [(0, 0, 'V'), (0, 2, 'V'), (0, 4, 'V'), (0, 6, 'V'), (0, 8, 'V'), (9, 0, 'H'), (9, 4, 'H'), (9, 6, 'H'), (9, 9, 'H'), (4, 8, 'H')]

def play(board, attacks, lastmove, sunk):
    for c in range(len(attacks[0])):
        for r in range(len(attacks)):
            if not attacks[r][c].is_hit:
                return (r, c)
    return None
