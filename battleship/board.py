from block import block
from ship import ship

class board:
    def __init__(self, w, h):
        self.dim = (block(0, 0), block(w, h))
        self.lost = False

        self.ships = []
        self.shiplens = (4, 3, 3, 2, 2, 2, 1, 1, 1, 1)

        self.last_attacked = None
        self.board = [[block(i, j) for j in range(h)] for i in range(w)]

    def deploy(self, ships):
        # check number of ships
        if len(ships) != len(self.shiplens):
            self.lost = True
        # check if ship fits in the board
        for i in range(len(ships)):
            s = ship(ships[i], self.shiplens[i])
            if s.fit_in(self.dim):
                self.ships.append(s)
            else:
                self.lost = True

    def get(self):
        return [[b.cp() for b in r] for r in self.board]

    def hidden(self):
        return [[b.hide_cp() for b in r] for r in self.board]

    def skipped(self):
        return self.last_attacked == None

    def attack(self, h):
        self.last_attacked = h
        if h == None:
            return None

        b = self.board[h[0]][h[1]]
        b.is_hit = True
        for s in self.ships:
            if s.is_hit(b):
                return s.is_sunk()
