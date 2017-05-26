from block import block
from ship import ship

class board:
    def __init__(self, w, h):
        self.dim = (block(0, 0), block(w, h))
        self.lost = False

        self.ships = []
        self.shiplens = (4, 3, 3, 2, 2, 2, 1, 1, 1, 1)

        self.last_attacked = None
        self.last_sunk = 0

        self.opp_skipped = False
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
                # check overlap & occupy board
                for r, c in s.blocks():
                    if self.board[r][c].is_occupied:
                        self.lost = True
                        return

                    self.board[r][c].is_occupied = True
            else:
                self.lost = True
                return

    def get(self):
        return [[b.cp() for b in r] for r in self.board]

    def hidden(self):
        return [[b.hide_cp() for b in r] for r in self.board]

    def attack(self, h):
        self.last_sunk = 0
        self.last_attacked = h
        if h == None: # player skipped
            self.opp_skipped = True
            return

        # inside the board? and not already hit?
        b = self.board[h[0]][h[1]]
        if not b.with_in(*self.dim) or b.is_hit:
            self.last_attacked = None
            self.opp_skipped = True
            return

        b.is_hit = True
        self.opp_skipped = False
        # check if it hit a ship
        for s in self.ships:
            if s.is_hit(b):
                if s.is_sunk:
                    self.last_sunk = s.l
                break

        # check if lost
        if all([s.is_sunk for s in self.ships]):
            self.lost = True
