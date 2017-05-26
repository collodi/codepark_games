from block import block

class ship:
    def __init__(self, ship, length):
        row, col, orient = ship
        self.s = block(row, col)
        if orient == 'H':
            self.e = self.s.offset_by(0, length - 1)
        else:
            self.e = self.s.offset_by(length - 1, 0)

        self.orient = orient
        self.l = length
        self.hits = 0
        self.is_sunk = False

    def fit_in(self, dim):
        return self.s.with_in(*dim) and self.e.with_in(*dim)

    def is_hit(self, b):
        if not self.is_sunk and b.with_in(self.s, self.e):
            self.hits += 1
            if self.hits == self.l:
                self.is_sunk = True
            return True
        return False

    def blocks(self):
        adder = (0, 1) if self.orient == 'H' else (1, 0)
        return [(self.s.r + adder[0] * i, self.s.c + adder[1] * i) for i in range(self.l)]
