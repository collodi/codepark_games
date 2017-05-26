from block import block

class ship:
    def __init__(self, ship, length):
        row, col, orient = ship
        self.s = block(row, col)
        if orient == 'H':
            self.e = self.s.offset_by(0, length - 1)
        else:
            self.e = self.s.offset_by(length - 1, 0)
        self.l = length
        self.hits = 0

    def fit_in(self, dim):
        return self.s.with_in(*dim) and self.e.with_in(*dim)

    def is_hit(self, b):
        if not b.hit and b.between(self.s, self.e):
            self.hits += 1
            return True
        return False

    def is_sunk(self):
        return self.l if self.hits == self.l else 0
