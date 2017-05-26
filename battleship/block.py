import copy

class block:
    def __init__(self, r, c):
        self.r = r
        self.c = c
        self.is_occupied = False
        self.is_hit = False

    def offset_by(self, r, c):
        return block(self.r + r, self.c + c)

    def with_in(self, b1, b2):
        return b1.r <= self.r <= b2.r and b1.c <= self.c <= b2.c

    def cp(self):
        return copy.deepcopy(self)

    def hide_cp(self):
        c = self.cp()
        c.is_occupied = None
        return c
