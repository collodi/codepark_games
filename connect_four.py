#!/usr/bin/python3

import sys
import signal
import importlib

class TurnTimeout(Exception):
    pass

class connect_four:
    def __init__(self, p1, p2):
        self.board = [[None for j in range(7)] for i in range(6)]
        self.capacity = len(self.board) * len(self.board[0])
        self.turn = False # == 0
        self.played = 0
        self.lastspot = (None, None)
        self.mylast = (None, None)
        self.skipped = 0

        self.player_names = [p1, p2]
        self.players = [importlib.import_module('%s.players.%s' % (self.__class__.__name__, p)) for p in [p1, p2]]
        signal.signal(signal.SIGALRM, self.timed_out)

    def timed_out(self, num, frame):
        raise TurnTimeout()

    def get(self, spot):
        return self.board[spot[0]][spot[1]]

    def valid_type(self, spot):
        return isinstance(spot, tuple) and len(spot) > 1 and isinstance(spot[0], int) and isinstance(spot[1], int)

    def valid_range(self, spot):
        try:
            self.get(spot)
            return True
        except IndexError:
            return False

    def is_empty(self, spot):
        return self.get(spot) == None

    def playspot(self, spot):
        if not self.valid_type(spot) or not self.valid_range(spot) or not self.is_empty(spot):
            return False

        for i in range(spot[0] + 1, len(self.board)):
            if self.board[i][spot[1]] == None:
                return False

        self.board[spot[0]][spot[1]] = self.turn
        return True

    def playturn(self):
        retry = False
        signal.alarm(3)
        try:
            while True:
                spot = self.players[self.turn].play(self.board, self.lastspot, self.mylast, self.turn, retry)
                if spot == (None, None):
                    raise TurnTimeout()
                elif self.playspot(spot):
                    self.mylast = self.lastspot
                    self.lastspot = spot
                    self.skipped = 0
                    self.played += 1
                    break
                retry = True
        except TurnTimeout:
            self.mylast = self.lastspot
            self.lastspot = (None, None)
            self.skipped += 1
        finally:
            signal.alarm(0)
            self.turn = not self.turn

    def check_line(self, l, v):
        c = 0
        for i in range(len(l)):
            if v == l[i]:
                c += 1
            elif c == 4:
                return True
            else:
                c = 0
        if c == 4:
            return True
        return False

    def over(self):
        if self.skipped > 1:
            return 2 # draw
        
        v = not self.turn
        r, c = self.lastspot
        if r == None or c == None:
            return -1
        
        # vertical
        vert = [self.board[i][c] for i in range(len(self.board))]
        # diagonal /
        lbtr = [self.board[r-i][c+i] for i in range(-min(c, len(self.board)-r-1),  min(len(self.board[0])-c, r+1))]
        # diagonal \
        ltrb = [self.board[r+i][c-i] for i in range(-min(c, r),  min(len(self.board[0])-c, len(self.board)-r))]
        
        if self.check_line(self.board[r], v) or self.check_line(vert, v) or self.check_line(lbtr, v) or self.check_line(ltrb, v):
            return v # winner player number

        if self.played == self.capacity:
            return 2
        return -1 # keep playing

    def start(self):
        while True:
            result = self.over()
            if result == 2:
                print ('Game ended with a draw')
                break
            elif result != -1:
                print ('%s won!' % self.player_names[result])
                break

            self.playturn()

if __name__ == '__main__':
    game = connect_four(sys.argv[1], sys.argv[2])
    game.start()
